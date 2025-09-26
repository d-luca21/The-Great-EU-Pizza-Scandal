USE mamma_mia;

CREATE OR REPLACE VIEW v_pizza_cost AS
SELECT
  p.pizza_id,
  p.name AS pizza_name,
  -- convert grams to kg before multiplying by €/kg
  SUM( (pi.qty_unit / 1000.0) * i.cost_per_unit ) AS base_cost,
  MAX(i.is_meat)           AS contains_meat,
  MAX(i.is_animal_product) AS contains_animal_product
FROM pizzas p
JOIN pizza_ingredients pi ON pi.pizza_id = p.pizza_id
JOIN ingredients i        ON i.ingredient_id = pi.ingredient_id
GROUP BY p.pizza_id, p.name;

CREATE OR REPLACE VIEW v_menu_pizzas AS
SELECT
  c.pizza_id,
  c.pizza_name AS name,
  ROUND(c.base_cost * 1.40 * 1.09 * 0.80, 2) AS price_S,
  ROUND(c.base_cost * 1.40 * 1.09 * 1.00, 2) AS price_M,
  ROUND(c.base_cost * 1.40 * 1.09 * 1.30, 2) AS price_L,
  (c.contains_meat = 0)                                  AS is_vegetarian,
  (c.contains_meat = 0 AND c.contains_animal_product = 0) AS is_vegan
FROM v_pizza_cost c
JOIN pizzas p ON p.pizza_id = c.pizza_id
WHERE p.active = 1;
