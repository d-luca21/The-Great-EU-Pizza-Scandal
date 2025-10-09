# app/reports.py
import os
from dotenv import load_dotenv
import mysql.connector as mysql

load_dotenv(os.path.join("app", ".env"))

CFG = {
    "host": os.getenv("DB_HOST", "127.0.0.1"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASS", "root"),
    "database": os.getenv("DB_NAME", "mamma_mia"),
}

# ---------- tiny util to pretty-print rows ----------
def print_rows(title, cursor, rows):
    print(f"\n=== {title} ===")
    if not rows:
        print("(no rows)")
        return
    cols = [d[0] for d in cursor.description]
    print(" | ".join(cols))
    for r in rows:
        print(" | ".join("" if v is None else str(v) for v in r))

def run(conn, title, sql, params=None):
    cur = conn.cursor()
    cur.execute(sql, params or ())
    rows = cur.fetchall()
    print_rows(title, cur, rows)
    cur.close()

def main():
    try:
        cnx = mysql.connect(**CFG)
    except mysql.Error as e:
        print("DB connection failed:", e)
        print("Check app/.env (DB_HOST/PORT/USER/PASS/DB_NAME) and that MySQL is running.")
        return

    # A) Top 3 pizzas in the last 30 days
    run(cnx, "Top 3 pizzas (last 30 days)", """
        SELECT p.name,
               SUM(op.quantity) AS qty_30d
        FROM orders o
        JOIN order_pizzas op ON op.order_id = o.order_id
        JOIN pizzas p        ON p.pizza_id = op.pizza_id
        WHERE o.placed_at >= NOW() - INTERVAL 30 DAY
          AND o.status <> 'CANCELLED'
        GROUP BY p.pizza_id, p.name
        ORDER BY qty_30d DESC, p.name ASC
        LIMIT 3;
    """)

    # B) Undelivered / in-progress orders (with postal code + age)
    run(cnx, "Undelivered / in-progress orders (with postal code & age)", """
        SELECT o.order_id,
               o.status,
               o.placed_at,
               c.full_name AS customer,
               a.postal_code,
               TIMESTAMPDIFF(YEAR, c.birth_date, o.placed_at) AS age_at_order,
               d.assigned_to,
               d.assigned_at,
               d.delivered_at
        FROM orders o
        JOIN customers  c ON c.customer_id = o.customer_id
        JOIN addresses  a ON a.address_id  = o.address_id
        LEFT JOIN deliveries d ON d.order_id = o.order_id
        WHERE o.status IN ('PLACED','PREPARING','OUT_FOR_DELIVERY')
           OR d.delivered_at IS NULL
        ORDER BY o.placed_at DESC
        LIMIT 50;
    """)

    # C) Monthly earnings by gender (F/M/X/NULL→ '?')
    run(cnx, "Monthly earnings by gender", """
        WITH pizza_tot AS (
          SELECT order_id, SUM(fn_pizza_price(pizza_id, size) * quantity) AS amt
          FROM order_pizzas GROUP BY order_id
        ),
        drink_tot AS (
          SELECT od.order_id, SUM(od.quantity * dr.unit_price) AS amt
          FROM order_drinks od JOIN drinks dr ON dr.drink_id = od.drink_id
          GROUP BY od.order_id
        ),
        dessert_tot AS (
          SELECT oe.order_id, SUM(oe.quantity * ds.unit_price) AS amt
          FROM order_desserts oe JOIN desserts ds ON ds.dessert_id = oe.dessert_id
          GROUP BY oe.order_id
        )
        SELECT COALESCE(c.gender,'?') AS gender,
               DATE_FORMAT(o.placed_at,'%Y-%m') AS ym,
               ROUND(SUM(COALESCE(pizza_tot.amt,0) + COALESCE(drink_tot.amt,0) + COALESCE(dessert_tot.amt,0)),2) AS gross
        FROM orders o
        JOIN customers c ON c.customer_id = o.customer_id
        LEFT JOIN pizza_tot   ON pizza_tot.order_id   = o.order_id
        LEFT JOIN drink_tot   ON drink_tot.order_id   = o.order_id
        LEFT JOIN dessert_tot ON dessert_tot.order_id = o.order_id
        WHERE o.status <> 'CANCELLED'
        GROUP BY gender, ym
        ORDER BY ym, gender;
    """)

    # D) Monthly earnings by postal code
    run(cnx, "Monthly earnings by postal code", """
        WITH pizza_tot AS (
          SELECT order_id, SUM(fn_pizza_price(pizza_id, size) * quantity) AS amt
          FROM order_pizzas GROUP BY order_id
        ),
        drink_tot AS (
          SELECT od.order_id, SUM(od.quantity * dr.unit_price) AS amt
          FROM order_drinks od JOIN drinks dr ON dr.drink_id = od.drink_id
          GROUP BY od.order_id
        ),
        dessert_tot AS (
          SELECT oe.order_id, SUM(oe.quantity * ds.unit_price) AS amt
          FROM order_desserts oe JOIN desserts ds ON ds.dessert_id = oe.dessert_id
          GROUP BY oe.order_id
        )
        SELECT a.postal_code,
               DATE_FORMAT(o.placed_at,'%Y-%m') AS ym,
               ROUND(SUM(COALESCE(pizza_tot.amt,0) + COALESCE(drink_tot.amt,0) + COALESCE(dessert_tot.amt,0)),2) AS gross
        FROM orders o
        JOIN addresses a ON a.address_id = o.address_id
        LEFT JOIN pizza_tot   ON pizza_tot.order_id   = o.order_id
        LEFT JOIN drink_tot   ON drink_tot.order_id   = o.order_id
        LEFT JOIN dessert_tot ON dessert_tot.order_id = o.order_id
        WHERE o.status <> 'CANCELLED'
        GROUP BY a.postal_code, ym
        ORDER BY ym, a.postal_code;
    """)

    # E) Monthly earnings by AGE GROUP
    run(cnx, "Monthly earnings by age group", """
        WITH pizza_tot AS (
          SELECT order_id, SUM(fn_pizza_price(pizza_id, size) * quantity) AS amt
          FROM order_pizzas GROUP BY order_id
        ),
        drink_tot AS (
          SELECT od.order_id, SUM(od.quantity * dr.unit_price) AS amt
          FROM order_drinks od JOIN drinks dr ON dr.drink_id = od.drink_id
          GROUP BY od.order_id
        ),
        dessert_tot AS (
          SELECT oe.order_id, SUM(oe.quantity * ds.unit_price) AS amt
          FROM order_desserts oe JOIN desserts ds ON ds.dessert_id = oe.dessert_id
          GROUP BY oe.order_id
        ),
        orders_tot AS (
          SELECT o.order_id, o.placed_at, c.birth_date,
                 (COALESCE(pizza_tot.amt,0)+COALESCE(drink_tot.amt,0)+COALESCE(dessert_tot.amt,0)) AS gross
          FROM orders o
          JOIN customers c ON c.customer_id = o.customer_id
          LEFT JOIN pizza_tot   ON pizza_tot.order_id   = o.order_id
          LEFT JOIN drink_tot   ON drink_tot.order_id   = o.order_id
          LEFT JOIN dessert_tot ON dessert_tot.order_id = o.order_id
          WHERE o.status <> 'CANCELLED'
        )
        SELECT CASE
                 WHEN TIMESTAMPDIFF(YEAR, birth_date, placed_at) < 18 THEN '<18'
                 WHEN TIMESTAMPDIFF(YEAR, birth_date, placed_at) BETWEEN 18 AND 25 THEN '18–25'
                 WHEN TIMESTAMPDIFF(YEAR, birth_date, placed_at) BETWEEN 26 AND 40 THEN '26–40'
                 WHEN TIMESTAMPDIFF(YEAR, birth_date, placed_at) BETWEEN 41 AND 60 THEN '41–60'
                 ELSE '60+'
               END AS age_group,
               DATE_FORMAT(placed_at,'%Y-%m') AS ym,
               ROUND(SUM(gross),2) AS earnings
        FROM orders_tot
        GROUP BY age_group, ym
        ORDER BY ym, age_group;
    """)

    # F) NEW — Promo & Birthday: last 30 days (counts)
    run(cnx, "Promo-code orders (last 30 days)", """
        SELECT COUNT(*) AS promo_orders_30d
        FROM orders
        WHERE discount_code_id IS NOT NULL
          AND status <> 'CANCELLED'
          AND placed_at >= NOW() - INTERVAL 30 DAY;
    """)

    run(cnx, "Birthday orders (last 30 days)", """
        SELECT COUNT(*) AS birthday_orders_30d
        FROM orders o
        JOIN customers c ON c.customer_id = o.customer_id
        WHERE o.status <> 'CANCELLED'
          AND DAY(c.birth_date) = DAY(o.placed_at)
          AND MONTH(c.birth_date) = MONTH(o.placed_at)
          AND o.placed_at >= NOW() - INTERVAL 30 DAY;
    """)

    # G) NEW — Promo & Birthday: per month (counts)
    run(cnx, "Promo-code orders per month", """
        SELECT DATE_FORMAT(placed_at, '%Y-%m') AS ym,
               COUNT(*) AS promo_orders
        FROM orders
        WHERE discount_code_id IS NOT NULL
          AND status <> 'CANCELLED'
        GROUP BY ym
        ORDER BY ym;
    """)

    run(cnx, "Birthday orders per month", """
        SELECT DATE_FORMAT(o.placed_at, '%Y-%m') AS ym,
               COUNT(*) AS birthday_orders
        FROM orders o
        JOIN customers c ON c.customer_id = o.customer_id
        WHERE o.status <> 'CANCELLED'
          AND DAY(c.birth_date) = DAY(o.placed_at)
          AND MONTH(c.birth_date) = MONTH(o.placed_at)
        GROUP BY ym
        ORDER BY ym;
    """)

    # (Optional) H) NEW — Last 30 days detailed flag view
    run(cnx, "Orders (last 30 days) with promo/birthday flags", """
        SELECT o.order_id,
               DATE(o.placed_at) AS day,
               c.full_name,
               a.postal_code,
               IF(o.discount_code_id IS NOT NULL, 1, 0) AS used_discount_code,
               IF(DAY(c.birth_date)=DAY(o.placed_at) AND MONTH(c.birth_date)=MONTH(o.placed_at), 1, 0) AS is_birthday
        FROM orders o
        JOIN customers c ON c.customer_id = o.customer_id
        JOIN addresses a ON a.address_id  = o.address_id
        WHERE o.status <> 'CANCELLED'
          AND o.placed_at >= NOW() - INTERVAL 30 DAY
        ORDER BY o.placed_at DESC
        LIMIT 50;
    """)

    cnx.close()

if __name__ == "__main__":
    main()
