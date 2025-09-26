USE mamma_mia;

-- Ingredients stored as €/kg (NOT per gram)
INSERT INTO ingredients(name, cost_per_unit, unit, is_meat, is_animal_product) VALUES
 ('Dough',         5.00,  'kg', 0, 0),
 ('Tomato sauce',  6.00,  'kg', 0, 0),
 ('Mozzarella',   35.00,  'kg', 0, 1),
 ('Basil',        40.00,  'kg', 0, 0),
 ('Pepperoni',    20.00,  'kg', 1, 0),
 ('Mushroom',      6.00,  'kg', 0, 0);

-- Pizzas
INSERT INTO pizzas(name, active) VALUES
 ('Margherita', 1),
 ('Pepperoni',  1),
 ('Funghi',     1);

-- Recipe (qty in grams — view converts g → kg)
INSERT INTO pizza_ingredients(pizza_id, ingredient_id, qty_unit)
SELECT p.pizza_id, i.ingredient_id, x.qty FROM (
  SELECT 'Margherita' AS p, 'Dough'         AS i, 250 AS qty UNION ALL
  SELECT 'Margherita',      'Tomato sauce',          80        UNION ALL
  SELECT 'Margherita',      'Mozzarella',           120        UNION ALL
  SELECT 'Margherita',      'Basil',                  5        UNION ALL
  SELECT 'Pepperoni',       'Dough',                250        UNION ALL
  SELECT 'Pepperoni',       'Tomato sauce',          80        UNION ALL
  SELECT 'Pepperoni',       'Mozzarella',           120        UNION ALL
  SELECT 'Pepperoni',       'Pepperoni',             70        UNION ALL
  SELECT 'Funghi',          'Dough',                250        UNION ALL
  SELECT 'Funghi',          'Tomato sauce',          80        UNION ALL
  SELECT 'Funghi',          'Mozzarella',           120        UNION ALL
  SELECT 'Funghi',          'Mushroom',              90
) x
JOIN pizzas p      ON p.name = x.p
JOIN ingredients i ON i.name = x.i;
