import os, json, sys, re
from datetime import datetime
from decimal import Decimal
from argparse import ArgumentParser
from dotenv import load_dotenv
import mysql.connector as mysql

load_dotenv(os.path.join("app", ".env"))

CFG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASS", "root"),
    "database": os.getenv("DB_NAME", "mamma-mia")
}

BIRTHDAY_FREE_DRINK_QTY = 1

def load_json_arg(s: str):
    s = s.strip()
    
    if s.startswith("@"):
        with open(s[1:], "r", encoding = "utf-8") as f: return json.load(f)

    try: return json.loads(s)
    except json.JSONDecodeError:
        t = re.sub(r'([{,]\s*)([A-Za-z_]\w*)\s*:', r'\1"\2":', s)
        t = re.sub(r':\s*([A-Za-z_]\w*)\s*([,}])', r': "\1"\2', t)
        return json.loads(t)

def d(x): return Decimal(str(x))

def parse_args():
    ap = ArgumentParser(description="Place an order (single traansaction).")
    ap.add_argument("--customer-id", type = int, required = True)
    ap.add_argument("--address-id", type = int, required = True)
    ap.add_argument("--postal-code", type = str, required = True)
    ap.add_argument("--pizzas", type = str, default = "[]")
    ap.add_argument("--drinks", type = str, default = "[]")
    ap.add_argument("--desserts", type = str, default = "[]")
    ap.add_argument("--discount-code", type = str, default = None)
    return ap.parse_args()

def fetch_price(curr, pizza_id, size):
    curr.execute("SELECT fn_pizza_price(%s, %s)", (pizza_id, size))
    row = curr.fetchone()
    if row is None or row[0] is None: raise ValueError(f"Unknown pizza_id/size: {pizza_id}/{size}")
    return d(row[0])

def is_birthday(curr, customer_id, now_dt):
    curr.execute("SELECT fn_is_birthday(%s, %s)", (customer_id, now_dt))
    return bool(curr.fetchone()[0])

def lifetime_pizza_count(curr, customer_id):
    curr.execute("SELECT fn_customer_pizza_count(%s)", (customer_id,))
    return int(curr.fetchone()[0])

def validate_and_lock_discount(curr, code, customer_id):
    curr.callproc("sp_validate_and_lock_discount_code", [code, customer_id, None, None])
    curr.execute("SELECT discount_code_id, percent_off FROM discount_codes WHERE code = %s", (code,))
    rid = curr.fetchone()
    if not rid: raise ValueError("Invalid discount code (post-validate)")
    return int(rid[0]), d(rid[1])

def pick_driver(curr, postal_code):
    curr.execute(
    """
        SELECT dz.delivery_person_id
        FROM delivery_zones dz
        JOIN v_driver_last_assignment v ON v.delivery_person_id = dz.delivery_person_id
        WHERE dz.postal_code = %s
        AND v.active_deliveries = 0
        AND (v.last_assigned_at IS NULL OR v.last_assigned_at <= (NOW() - INTERVAL 30 MINUTE))
        ORDER BY COALESCE(v.last_assigned_at, CAST('1970-01-01 00:00:00' AS DATETIME)) ASC, dz.delivery_person_id ASC
        LIMIT 1
    """, (postal_code,))

    row = curr.fetchone()
    if row: return int(row[0])

    curr.execute(
        """
        SELECT dz.delivery_person_id
        FROM delivery_zones dz
        JOIN v_driver_last_assignment v ON v.delivery_person_id = dz.delivery_person_id
        WHERE dz.postal_code = %s
        AND v.active_deliveries = 0
        ORDER BY COALESCE(v.last_assigned_at, CAST('1970-01-01 00:00:00' AS DATETIME)) ASC, dz.delivery_person_id ASC
        LIMIT 1
        """, (postal_code,)
    )

    row = curr.fetchone()
    if row: return int(row[0])

    curr.execute(
        """
        SELECT dz.delivery_person_id
        FROM delivery_zones dz
        WHERE dz.postal_code = %s
        ORDER BY dz.delivery_person_id ASC
        LIMIT 1
        """, (postal_code,)
    )

    row = curr.fetchone()
    if row: return int(row[0])
    raise RuntimeError("No driver covers this postal code. add a delivery_zones row.")

def main(): 
    args = parse_args()
    print("argv: ", sys.argv)
    print("pizzas raw: ", repr(args.pizzas))

    try: cnx = mysql.connect(**CFG)
    except mysql.Error as e:
        print("DB connection failed.", e)
        print("Tip: check DB reads, port 3306, and DB_NAME matches your schema.")
        sys.exit(1)

    curr = cnx.cursor()
    pizzas = load_json_arg(args.pizzas)
    drinks = load_json_arg(args.drinks)
    desserts = load_json_arg(args.desserts)
    cnx.start_transaction()

    try:
        now_dt = datetime.now()

        curr.execute(
            """
            INSERT INTO orders(customer_id, address_id, placed_at, status, discount_code_id)
            VALUES (%s, %s, %s, 'PLACED', NULL)
            """, (args.customer_id, args.address_id, now_dt)
        )

        order_id = curr.lastrowid

        for i in pizzas:
            curr.execute(
                """
                INSERT INTO order_pizzas(order_id, pizza_id, size, quantity)
                VALUES (%s, %s, %s, %s)
                """, (order_id, int(i["pizza_id"]), i["size"], int(i["qty"]))
            )

        for i in drinks:
            curr.execute(
                """
                INSERT INTO order_drinks(order_id, drink_id, quantity)
                VALUES (%s, %s, %s)
                """, (order_id, int(i["drink_id"]), int(i["qty"]))
            )

        for i in desserts:
            curr.execute(
                """
                INSERT INTO order_desserts(order_id, dessert_id, quantity)
                VALUES (%s, %s, %s, %s)
                """, (order_id, int(i["dessert_id"]), int(i["qty"]))
            )

        subtotal = d("0.00")
        pizza_line_prices = []

        for i in pizzas:
            unit = fetch_price(curr, int(i["pizza_id"]), i["size"])
            qty = int(i["qty"])
            line_total = unit*qty
            pizza_line_prices.append((line_total, unit, qty))
            subtotal += line_total

        if drinks:
            for i in drinks:
                curr.execute("SELECT unit_price FROM drinks WHERE drink_id = %s", (int(i["drink_id"]),))
                price = curr.fetchone()
                if not price: raise ValueError(f"Unknown drink_id {i['drink_id']}")
                subtotal += d(price[0])*int(i["qty"])

        for i in desserts:
           curr.execute("SELECT unit_price FROM desserts WHERE dessert_id = %s", (int(i["dessert_id"]),))
           price = curr.fetchone()
           if not price: raise ValueError(f"Unknown dessert_id {i['dessert_id']}")
           subtotal += d(price[0])*int(i["qty"])

        total = subtotal 

        if is_birthday(curr, args.customer_id, now_dt):
            if pizza_line_prices:
                cheapest_unit = min(pizza_line_prices, key = lambda t: t[1])[1]
                total -= cheapest_unit

            if drinks:
                cheapest_drink_unit = None

                for i in drinks:
                    curr.execute("SELECT unit_price FROM drinks WHERE drink_id = %s", (int(i["drink_id"]),))
                    price = d(curr.fetchone()[0])
                    if cheapest_drink_unit is None or price < cheapest_drink_unit: cheapest_drink_unit = price
                    
                if cheapest_drink_unit is not None: total -= cheapest_drink_unit

        prior_pizzas = lifetime_pizza_count(curr, args.customer_id)
        if prior_pizzas >= 10: total = (total*d("0.90")).quantize(Decimal("0.01"))

        if args.discount_code:
            dc_id, dc_pct = validate_and_lock_discount(curr, args.discount_code, args.customer_id)
            curr.execute("UPDATE orders SET discount_code_id = %s WHERE order_id = %s", (dc_id, order_id))
            if dc_pct > 0: total = (total*(d("1.00") - dc_pct/d("100.0"))).quantize(Decimal("0.01"))

        driver_id = pick_driver(curr, args.postal_code)

        curr.execute(
            """
            INSERT INTO deliveries(order_id, assigned_to, assigned_at, delivered_at)
            VALUES (%s, %s, NOW(), NULL)
            """, (order_id, driver_id)
        )

        cnx.commit()
        print("Order placed.")
        print(f"Order ID: {order_id}")
        print(f"Subtotal: {subtotal:.2f} euros")
        print(f"Total after discounts: {total:.2f} euros")
        print(f"Assigned driver id: {driver_id}")

    except Exception as e:
        cnx.rollback()
        print("Order failed - rolled back.")
        print("Reason: ", e)

    finally:
        curr.close()
        cnx.close()

if __name__ == "__main__": main()

            
