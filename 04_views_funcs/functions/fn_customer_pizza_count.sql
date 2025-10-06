DROP FUNCTION IF EXISTS fn_customer_pizza_count;
CREATE FUNCTION fn_customer_pizza_count(p_customer_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_cnt INT;
    SELECT COALESCE(SUM(op.quantity), 0) INTO v_cnt
    FROM orders o
    JOIN order_pizzas op ON op.order_id = o.order_id
    WHERE o.customer_id = p.customer_id
    AND o.status <> 'CANCELLED';
    RETURN COALESCE(v_cnt, 0);
END;