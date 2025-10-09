USE mamma_mia;

-- ============================
-- Ingredients (€/kg)
-- ============================
INSERT INTO ingredients(name, cost_per_unit, unit, is_meat, is_animal_product) VALUES
 ('Dough',              5.00,  'kg', 0, 0),
 ('Tomato sauce',       6.00,  'kg', 0, 0),
 ('Mozzarella',        35.00,  'kg', 0, 1),
 ('Basil',             40.00,  'kg', 0, 0),
 ('Pepperoni',         20.00,  'kg', 1, 0),
 ('Mushroom',           6.00,  'kg', 0, 0),
 ('Garlic',            80.00,  'kg', 0, 0),
 ('Oregano',           60.00,  'kg', 0, 0),
 ('Vegan Mozzarella',  15.00,  'kg', 0, 0),
 ('Red onions',        65.00,  'kg', 0, 0),
 ('Bell peppers',      68.00,  'kg', 0, 0),
 ('Black olives',      85.00,  'kg', 0, 0),
 ('Ham',              175.00,  'kg', 1, 1),
 ('Pineapple',         60.00,  'kg', 0, 0),
 ('BBQ sauce',         55.00,  'kg', 0, 0),
 ('Chicken',          190.00,  'kg', 1, 1),
 ('Jalapenos',         80.00,  'kg', 0, 0),
 ('Spinach',           65.00,  'kg', 0, 0),
 ('Artichokes',        95.00,  'kg', 0, 0);

-- ============================
-- Pizzas (10)
-- ============================
INSERT INTO pizzas(name, active) VALUES
 ('Margherita', 1),
 ('Pepperoni',  1),
 ('Funghi',     1),
 ('Marinara',   1),
 ('Quattro Formaggi', 1),
 ('Veggie Supreme',   1),
 ('Hawaiian',   1),
 ('BBQ Chicken',1),
 ('Diavola',    1),
 ('Primavera',  1);

-- ============================
-- Recipes (qty in grams; our view converts g -> kg)
-- ============================
INSERT INTO pizza_ingredients(pizza_id, ingredient_id, qty_unit)
SELECT p.pizza_id, i.ingredient_id, x.qty
FROM (
  -- Margherita
  SELECT 'Margherita' AS p, 'Dough' AS i, 250 AS qty UNION ALL
  SELECT 'Margherita', 'Tomato sauce', 80 UNION ALL
  SELECT 'Margherita', 'Mozzarella', 120 UNION ALL
  SELECT 'Margherita', 'Basil', 5 UNION ALL

  -- Pepperoni
  SELECT 'Pepperoni', 'Dough', 250 UNION ALL
  SELECT 'Pepperoni', 'Tomato sauce', 80 UNION ALL
  SELECT 'Pepperoni', 'Mozzarella', 120 UNION ALL
  SELECT 'Pepperoni', 'Pepperoni', 70 UNION ALL

  -- Funghi
  SELECT 'Funghi', 'Dough', 250 UNION ALL
  SELECT 'Funghi', 'Tomato sauce', 80 UNION ALL
  SELECT 'Funghi', 'Mozzarella', 120 UNION ALL
  SELECT 'Funghi', 'Mushroom', 90 UNION ALL

  -- Marinara
  SELECT 'Marinara', 'Dough', 250 UNION ALL
  SELECT 'Marinara', 'Tomato sauce', 110 UNION ALL
  SELECT 'Marinara', 'Garlic', 8 UNION ALL
  SELECT 'Marinara', 'Oregano', 3 UNION ALL

  -- Quattro Formaggi (keeping one vegan cheese just for fun)
  SELECT 'Quattro Formaggi', 'Dough', 250 UNION ALL
  SELECT 'Quattro Formaggi', 'Tomato sauce', 60 UNION ALL
  SELECT 'Quattro Formaggi', 'Mozzarella', 100 UNION ALL
  SELECT 'Quattro Formaggi', 'Vegan Mozzarella', 80 UNION ALL
  SELECT 'Quattro Formaggi', 'Oregano', 3 UNION ALL

  -- Veggie Supreme
  SELECT 'Veggie Supreme', 'Dough', 250 UNION ALL
  SELECT 'Veggie Supreme', 'Tomato sauce', 90 UNION ALL
  SELECT 'Veggie Supreme', 'Vegan Mozzarella', 120 UNION ALL
  SELECT 'Veggie Supreme', 'Bell peppers', 60 UNION ALL
  SELECT 'Veggie Supreme', 'Red onions', 40 UNION ALL
  SELECT 'Veggie Supreme', 'Black olives', 30 UNION ALL
  SELECT 'Veggie Supreme', 'Mushroom', 50 UNION ALL

  -- Hawaiian
  SELECT 'Hawaiian', 'Dough', 250 UNION ALL
  SELECT 'Hawaiian', 'Tomato sauce', 80 UNION ALL
  SELECT 'Hawaiian', 'Mozzarella', 110 UNION ALL
  SELECT 'Hawaiian', 'Ham', 70 UNION ALL
  SELECT 'Hawaiian', 'Pineapple', 60 UNION ALL

  -- BBQ Chicken
  SELECT 'BBQ Chicken', 'Dough', 250 UNION ALL
  SELECT 'BBQ Chicken', 'BBQ sauce', 90 UNION ALL
  SELECT 'BBQ Chicken', 'Mozzarella', 120 UNION ALL
  SELECT 'BBQ Chicken', 'Chicken', 80 UNION ALL
  SELECT 'BBQ Chicken', 'Red onions', 35 UNION ALL

  -- Diavola
  SELECT 'Diavola', 'Dough', 250 UNION ALL
  SELECT 'Diavola', 'Tomato sauce', 80 UNION ALL
  SELECT 'Diavola', 'Mozzarella', 110 UNION ALL
  SELECT 'Diavola', 'Pepperoni', 80 UNION ALL
  SELECT 'Diavola', 'Jalapenos', 20 UNION ALL

  -- Primavera
  SELECT 'Primavera', 'Dough', 250 UNION ALL
  SELECT 'Primavera', 'Tomato sauce', 90 UNION ALL
  SELECT 'Primavera', 'Vegan Mozzarella', 110 UNION ALL
  SELECT 'Primavera', 'Spinach', 50 UNION ALL
  SELECT 'Primavera', 'Artichokes', 45 UNION ALL
  SELECT 'Primavera', 'Bell peppers', 40
) x
JOIN pizzas p      ON p.name = x.p
JOIN ingredients i ON i.name = x.i;

-- ============================
-- Drinks & Desserts
-- ============================
INSERT INTO drinks(name, unit_price, vegan) VALUES
 ('Sparkling water 500ml', 2.20, 1),
 ('Still water 500ml',     2.00, 1),
 ('Cola 330ml',            2.50, 1),
 ('Cola zero 330ml',       2.50, 1),
 ('Orange soda 330ml',     2.50, 1),
 ('Iced tea 500ml',        3.00, 1),
 ('Apple juice 250ml',     2.80, 1),
 ('Lemonade 400ml',        3.20, 1);

INSERT INTO desserts(name, unit_price, vegan) VALUES
 ('Tiramisu',               4.50, 0),
 ('Chocolate brownie',      3.80, 0),
 ('Vegan chocolate mousse', 4.20, 1),
 ('Panna cotta',            4.20, 0),
 ('Fruit salad',            3.50, 1);

-- ============================
-- Delivery crew & zones
-- ============================
INSERT INTO delivery_people(full_name, phone) VALUES
 ('Sara Koster',  '0610101010'),
 ('Bjorn Kuipers','0620202020'),
 ('Irish Peters', '0630303030');

INSERT INTO delivery_zones(delivery_person_id, postal_code)
SELECT d.delivery_person_id, x.postal_code
FROM (
  SELECT 'Sara Koster'  AS full_name, '6211AA' AS postal_code UNION ALL
  SELECT 'Sara Koster',               '6211EB'                UNION ALL
  SELECT 'Bjorn Kuipers',             '6221CC'                UNION ALL
  SELECT 'Bjorn Kuipers',             '6221DD'                UNION ALL
  SELECT 'Irish Peters',              '6217HB'                UNION ALL
  SELECT 'Irish Peters',              '6211JP'                UNION ALL
  SELECT 'Irish Peters',              '6211LN'                UNION ALL
  SELECT 'Irish Peters',              '6221KV'                UNION ALL
  SELECT 'Irish Peters',              '6212BB'                UNION ALL
  SELECT 'Irish Peters',              '6211NJ'
) x
JOIN delivery_people d ON d.full_name = x.full_name;

-- ============================
-- Customers (10)  (requires customers.gender to exist; if not, remove the gender column & values)
-- ============================
INSERT INTO customers(full_name, birth_date, email, phone, gender) VALUES
 ('Alice Janssens',   '1994-03-12', 'alice.j@example.com',   '+32 470 000 001', 'F'),
 ('Bert Peeters',     '1988-07-05', 'bert.p@example.com',    '+32 470 000 002', 'M'),
 ('Chiara Rossi',     '1999-11-21', 'chiara.r@example.com',  '+32 470 000 003', 'F'),
 ('Daan Verhoeven',   '1975-02-18', 'daan.v@example.com',    '+32 470 000 004', 'M'),
 ('Eva Müller',       '2001-09-09', 'eva.m@example.com',     '+32 470 000 005', 'F'),
 ('Félix Dubois',     '1992-01-25', 'felix.d@example.com',   '+32 470 000 006', 'M'),
 ('Gita Kaur',        '1985-12-30', 'gita.k@example.com',    '+32 470 000 007', 'F'),
 ('Hugo Schmidt',     '1968-04-14', 'hugo.s@example.com',    '+32 470 000 008', 'M'),
 ('Ines Moretti',     '1997-06-03', 'ines.m@example.com',    '+32 470 000 009', 'F'),
 ('Joris De Smet',    '2003-10-27', 'joris.d@example.com',   '+32 470 000 010', 'M');

-- ============================
-- Addresses (≥1 per customer) — postal codes match delivery_zones
-- ============================
INSERT INTO addresses(customer_id, line1, line2, city, postal_code, country)
SELECT c.customer_id, x.line1, NULL, x.city, x.postal_code, 'Belgium'
FROM (
  SELECT 'alice.j@example.com'  AS email, 'Rue A 1'  AS line1, 'Brussels' AS city, '6211AA' AS postal_code UNION ALL
  SELECT 'bert.p@example.com',    'Rue B 2',         'Brussels',           '6211EB'      UNION ALL
  SELECT 'chiara.r@example.com',  'Rue C 3',         'Brussels',           '6221CC'      UNION ALL
  SELECT 'daan.v@example.com',    'Rue D 4',         'Brussels',           '6221DD'      UNION ALL
  SELECT 'eva.m@example.com',     'Rue E 5',         'Brussels',           '6217HB'      UNION ALL
  SELECT 'felix.d@example.com',   'Rue F 6',         'Brussels',           '6211JP'      UNION ALL
  SELECT 'gita.k@example.com',    'Rue G 7',         'Brussels',           '6211LN'      UNION ALL
  SELECT 'hugo.s@example.com',    'Rue H 8',         'Brussels',           '6221KV'      UNION ALL
  SELECT 'ines.m@example.com',    'Rue I 9',         'Brussels',           '6212BB'      UNION ALL
  SELECT 'joris.d@example.com',   'Rue J 10',        'Brussels',           '6211NJ'
) x
JOIN customers c ON c.email = x.email;

-- Give two customers a second address (to test multi-address flow)
INSERT INTO addresses(customer_id, line1, line2, city, postal_code, country)
SELECT c.customer_id, x.line1, NULL, x.city, x.postal_code, 'Belgium'
FROM (
  SELECT 'alice.j@example.com' AS email, 'Rue A 11' AS line1, 'Brussels' AS city, '6211EB' AS postal_code UNION ALL
  SELECT 'bert.p@example.com',   'Rue B 22',        'Brussels',           '6211AA'
) x
JOIN customers c ON c.email = x.email;

-- ============================
-- A couple of discount codes for testing Week 4/5
-- ============================
INSERT INTO discount_codes(code, percent_off, single_use, redeemed_at, redeemed_by_customer) VALUES
 ('WELCOME10', 10.00, 0, NULL, NULL),
 ('ONETIME15', 15.00, 1, NULL, NULL);
