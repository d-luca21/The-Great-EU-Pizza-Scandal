USE mamma_mia;

-- A) Top 3 pizzas in the last 30 days
SELECT p.name,
       SUM(op.quantity) AS qty_30d
FROM orders o
JOIN order_pizzas op ON op.order_id = o.order_id
JOIN pizzas p        ON p.pizza_id = op.pizza_id
WHERE o.placed_at >= NOW() - INTERVAL 30 DAY
GROUP BY p.pizza_id, p.name
ORDER BY qty_30d DESC
LIMIT 3;

-- B) Undelivered / in-progress orders
SELECT o.order_id, o.status, o.placed_at,
       c.full_name,
       a.postal_code,
       d.assigned_to, d.assigned_at, d.delivered_at
FROM orders o
JOIN customers c  ON c.customer_id  = o.customer_id
JOIN addresses a  ON a.address_id   = o.address_id
LEFT JOIN deliveries d ON d.order_id = o.order_id
WHERE o.status IN ('PLACED','PREPARING','OUT_FOR_DELIVERY')
   OR d.delivered_at IS NULL
ORDER BY o.placed_at DESC
LIMIT 25;

-- C) Earnings by gender & month
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
GROUP BY gender, ym
ORDER BY ym, gender;

-- D) Earnings by postal code & month
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
GROUP BY a.postal_code, ym
ORDER BY ym, a.postal_code;

-- E) Earnings by age group & month
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
