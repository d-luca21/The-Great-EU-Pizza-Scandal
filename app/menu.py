import os
from dotenv import load_dotenv
import mysql.connector as mysql

# Load env vars from app/.env (relative to project root)
load_dotenv(os.path.join("app", ".env"))

CFG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASS", ""),
    "database": os.getenv("DB_NAME", "mamma_mia"),
}

def main():
    try:
        cnx = mysql.connect(**CFG)
    except mysql.Error as e:
        print("❌ DB connection failed:", e)
        print("Tip: use port 3306; check DB_PASS; and that database 'mamma_mia' exists.")
        return

    cur = cnx.cursor(dictionary=True)
    cur.execute("""
        SELECT pizza_id, name, price_S, price_M, price_L, is_vegetarian, is_vegan
        FROM v_menu_pizzas
        ORDER BY name
    """)
    rows = cur.fetchall()
    if not rows:
        print("No pizzas found. Did you run the seed + views SQL scripts?")
    else:
        print("Mamma Mia — Menu\n-----------------")
        for r in rows:
            tag = "vegan" if r["is_vegan"] else ("veg" if r["is_vegetarian"] else "non-veg")
            print(f"{r['name']:<12}  S €{r['price_S']:.2f}  M €{r['price_M']:.2f}  L €{r['price_L']:.2f}  [{tag}]")
    cur.close()
    cnx.close()

if __name__ == "__main__":
    main()
