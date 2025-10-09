USE mamma_mia;

-- Spread order dates across ~90 days (3 months).
WITH ranked AS (
  SELECT order_id,
         ROW_NUMBER() OVER (ORDER BY order_id) AS rn,
         COUNT(*) OVER () AS total_cnt
  FROM orders
)
UPDATE orders o
JOIN ranked r ON r.order_id = o.order_id
SET o.placed_at = DATE_ADD(DATE_SUB(CURDATE(), INTERVAL 90 DAY), INTERVAL CEIL(90.0 * r.rn / r.total_cnt) DAY);

-- Status mix: roughly 40% DELIVERED, 30% OUT_FOR_DELIVERY, 20% PREPARING, 10% PLACED
WITH r AS (
  SELECT order_id,
         ROW_NUMBER() OVER (ORDER BY placed_at) AS rn,
         COUNT(*) OVER () AS total_cnt
  FROM orders
)
UPDATE orders o
JOIN r ON r.order_id = o.order_id
SET o.status = CASE
                 WHEN r.rn <= 0.40 * r.total_cnt THEN 'DELIVERED'
                 WHEN r.rn <= 0.70 * r.total_cnt THEN 'OUT_FOR_DELIVERY'
                 WHEN r.rn <= 0.90 * r.total_cnt THEN 'PREPARING'
                 ELSE 'PLACED'
               END;

-- Assign delivered_at for delivered orders (placed_at + 60 min)
UPDATE deliveries d
JOIN orders o ON o.order_id = d.order_id
SET d.delivered_at = DATE_ADD(o.placed_at, INTERVAL 60 MINUTE)
WHERE o.status = 'DELIVERED';

-- Keep at least one very recent in-progress order (last 24h) so your "last 30 days" charts always show data
UPDATE orders
SET placed_at = NOW() - INTERVAL 1 DAY, status = 'OUT_FOR_DELIVERY'
WHERE order_id = (SELECT MAX(order_id) FROM orders);
