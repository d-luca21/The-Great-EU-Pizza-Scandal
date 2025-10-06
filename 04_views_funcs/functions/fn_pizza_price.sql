DROP FUNCTION IF EXISTS fn_pizza_price;
CREATE FUNCTION fn_pizza_price(p_pizza_id INT, p_size ENUM('S', 'M', 'L'))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_price DECIMAL(10, 2);
    IF p_size = 'S' THEN SELECT price_S INTO v_price FROM v_menu_pizzas WHERE pizza_id = p_pizza_id;
    ELSEIF p_size = 'M' THEN SELECT price_M INTO v_price FROM v_menu_pizzas WHERE pizza_id = p_pizza_id;
    ELSE SELECT price_L INTO v_price FROM v_menu_pizzas WHERE pizza_id = p_pizza_id;
    END IF;
    RETURN v_price;
END;