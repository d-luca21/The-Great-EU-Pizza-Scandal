USE mamma_mia;

DROP FUNCTION IF EXISTS fn_customer_pizza_count;
CREATE FUNCTION fn_customer_pizza_count(p_customer_id INT)
RETURNS INT
READS SQL DATA
RETURN (
  SELECT COALESCE(SUM(op.quantity), 0)
  FROM orders o
  JOIN order_pizzas op ON op.order_id = o.order_id
  WHERE o.customer_id = p_customer_id
    AND o.status <> 'CANCELLED'
);
