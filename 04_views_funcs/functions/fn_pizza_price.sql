USE mamma_mia;

DROP FUNCTION IF EXISTS fn_pizza_price;

CREATE FUNCTION fn_pizza_price(p_pizza_id INT, p_size CHAR(1))
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
RETURN (
  SELECT CASE p_size
           WHEN 'S' THEN price_S
           WHEN 'M' THEN price_M
           ELSE        price_L
         END
  FROM v_menu_pizzas
  WHERE pizza_id = p_pizza_id
);
