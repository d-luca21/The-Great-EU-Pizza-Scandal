USE mamma_mia;

-- Make sure codes exist (safe if they already do)
INSERT IGNORE INTO discount_codes(code, percent_off, single_use) VALUES ('WELCOME10', 10.00, 0);
INSERT IGNORE INTO discount_codes(code, percent_off, single_use) VALUES ('ONETIME15', 15.00, 1);

-- =========================
-- A) PROMO-CODE ORDER (today)
-- =========================
SET @cust := (SELECT customer_id FROM customers WHERE email='alice.j@example.com');
SET @addr := (SELECT address_id  FROM addresses WHERE customer_id=@cust ORDER BY address_id LIMIT 1);
SET @dc   := (SELECT discount_code_id FROM discount_codes WHERE code='WELCOME10');

INSERT INTO orders(customer_id, address_id, placed_at, status, discount_code_id)
VALUES (@cust, @addr, NOW(), 'PLACED', @dc);
SET @order := LAST_INSERT_ID();

-- 2 pizzas just for demo
INSERT INTO order_pizzas(order_id, pizza_id, size, quantity)
VALUES (@order, 1, 'M', 1),   -- Margherita M x1
       (@order, 2, 'S', 1);   -- Pepperoni  S x1

-- Assign a driver for the address postal code
SET @postal := (SELECT postal_code FROM addresses WHERE address_id=@addr);
SET @driver := (
  SELECT dz.delivery_person_id
  FROM delivery_zones dz
  JOIN v_driver_last_assignment v ON v.delivery_person_id = dz.delivery_person_id
  WHERE dz.postal_code = @postal
  ORDER BY COALESCE(v.last_assigned_at, CAST('1970-01-01 00:00:00' AS DATETIME)) ASC, dz.delivery_person_id ASC
  LIMIT 1
);

INSERT INTO deliveries(order_id, assigned_to, assigned_at, delivered_at)
VALUES (@order, @driver, NOW(), NULL);

-- =========================
-- B) BIRTHDAY ORDER (today)
-- We make Félix’s birth_date have today's month-day for the demo (keeps the year).
-- This is just to ensure the birthday condition matches today.
-- =========================
UPDATE customers
SET birth_date = STR_TO_DATE(CONCAT(YEAR(birth_date), DATE_FORMAT(NOW(), '-%m-%d')), '%Y-%m-%d')
WHERE email='felix.d@example.com';

SET @cust2 := (SELECT customer_id FROM customers WHERE email='felix.d@example.com');
SET @addr2 := (SELECT address_id  FROM addresses WHERE customer_id=@cust2 ORDER BY address_id LIMIT 1);

INSERT INTO orders(customer_id, address_id, placed_at, status, discount_code_id)
VALUES (@cust2, @addr2, NOW(), 'PLACED', NULL);
SET @order2 := LAST_INSERT_ID();

INSERT INTO order_pizzas(order_id, pizza_id, size, quantity)
VALUES (@order2, 3, 'L', 1);  -- Funghi L x1 (or any pizza_id you have)

SET @postal2 := (SELECT postal_code FROM addresses WHERE address_id=@addr2);
SET @driver2 := (
  SELECT dz.delivery_person_id
  FROM delivery_zones dz
  JOIN v_driver_last_assignment v ON v.delivery_person_id = dz.delivery_person_id
  WHERE dz.postal_code = @postal2
  ORDER BY COALESCE(v.last_assigned_at, CAST('1970-01-01 00:00:00' AS DATETIME)) ASC, dz.delivery_person_id ASC
  LIMIT 1
);

INSERT INTO deliveries(order_id, assigned_to, assigned_at, delivered_at)
VALUES (@order2, @driver2, NOW(), NULL);
