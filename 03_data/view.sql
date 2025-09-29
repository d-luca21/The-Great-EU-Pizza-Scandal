CREATE OR REPLACE VIEW `v_pizza_ingredient_cost` AS
SELECT
    p.`pizza_id`,
    p.`name` AS `pizza_name`,
    ROUND(SUM(pi.`qty_unit`*i.`cost_per_unit`), 4) AS `ingredient_cost_m`
FROM `pizzas` p
JOIN `pizza_ingredients` pi ON pi.`pizza_id` = p.`pizza_id`
JOIN `ingredients` i ON i.`ingredient_id` = pi.`ingredient_id`
GROUP BY p.`pizza_id`, p.`name`;

CREATE OR REPLACE VIEW `v_pizza_diets` AS
SELECT
    p.`pizza_id`,
    p.`name` AS `pizza_name`,
    CASE WHEN SUM(i.`is_animal_product`) = 0 THEN 1 ELSE 0 END AS `is_vegan`,
    CASE WHEN SUM(i.`is_meat`) = 0 THEN 1 ELSE 0 END AS `is_vegetarian`
FROM `pizzas` p
JOIN `pizza_ingredients` pi ON pi.`pizza_id` = p.`pizza_id`
JOIN `ingredients` i ON i.`ingredient_id` = pi.`ingredient_id`
GROUP BY p.`pizza_id`, p.`name`;

CREATE OR REPLACE VIEW `v_pizza_prices` AS
WITH `size_mult` AS (
    SELECT 'S' AS `size`, 'Small' AS `size_label`, 0.85 AS `mult` UNION ALL
    SELECT 'M', 'Medium', 1.00 UNION ALL
    SELECT 'L', 'Large', 1.25
),
`params` AS (SELECT 3.0 AS `cost_to_price_factor`)
SELECT
    p.`pizza_id`,
    p.`pizza_name`,
    sm.`size`,
    sm.`size_label`,
    ROUND(p.`ingredient_cost_m`*(SELECT `cost_to_price_factor` FROM `params`)*sm.`mult`, 2) AS `price_eur`
FROM `v_pizza_ingredient_cost` p
CROSS JOIN `size_mult` sm;

CREATE OR REPLACE VIEW `v_full_menu` AS
SELECT
    'PIZZA' AS `item_type`,
    pr.`pizza_name` AS `item_name`,
    pr.`size_label` AS `size_or_portion`,
    pr.`price_eur` AS `price_eur`,
    d.`is_vegetarian`,
    d.`is_vegan`
FROM `v_pizza_prices` pr
JOIN `v_pizza_diets` d ON d.`pizza_id` = pr.`pizza_id`
UNION ALL
SELECT 'DRINK', `name`, '-', `unit_price`, NULL, `vegan`
FROM `drinks`
UNION ALL
SELECT 'DESSERT', `name`, '1 pc', `unit_price`, NULL, `vegan`
FROM `desserts`;