USE mamma_mia;

-- This script seeds 26 presentation orders over ~3 months.
-- Requires: big_seed.sql already loaded (customers, addresses, pizzas, drinks, delivery_zones).

-- Helper: returns (customer_id, address_id, postal_code) for an email
-- (we'll just do SELECTs inline per order)

-- ====== ORDER 1 (DELIVERED ~85 days ago) — Alice ======
SET @cust := (SELECT customer_id FROM customers WHERE email='alice.j@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='alice.j@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 85 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Margherita'),'M',1),
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Pepperoni'),'S',1);
INSERT INTO order_drinks(order_id,drink_id,quantity)
VALUES (@oid,(SELECT drink_id FROM drinks WHERE name LIKE 'Cola %' LIMIT 1),1);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 85 DAY) + INTERVAL 20 MINUTE,
       (NOW() - INTERVAL 85 DAY) + INTERVAL 75 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 2 (DELIVERED ~80 days ago) — Bert ======
SET @cust := (SELECT customer_id FROM customers WHERE email='bert.p@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='bert.p@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 80 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Funghi'),'M',2);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 80 DAY) + INTERVAL 15 MINUTE,
       (NOW() - INTERVAL 80 DAY) + INTERVAL 60 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 3 (DELIVERED ~75 days ago) — Chiara ======
SET @cust := (SELECT customer_id FROM customers WHERE email='chiara.r@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='chiara.r@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 75 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Marinara'),'L',1),
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Veggie Supreme'),'M',1);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 75 DAY) + INTERVAL 25 MINUTE,
       (NOW() - INTERVAL 75 DAY) + INTERVAL 70 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 4 (DELIVERED ~72 days ago) — Daan ======
SET @cust := (SELECT customer_id FROM customers WHERE email='daan.v@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='daan.v@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 72 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='BBQ Chicken'),'L',1);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 72 DAY) + INTERVAL 18 MINUTE,
       (NOW() - INTERVAL 72 DAY) + INTERVAL 62 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 5 (DELIVERED ~69 days ago) — Eva ======
SET @cust := (SELECT customer_id FROM customers WHERE email='eva.m@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='eva.m@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 69 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Quattro Formaggi'),'M',1);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 69 DAY) + INTERVAL 14 MINUTE,
       (NOW() - INTERVAL 69 DAY) + INTERVAL 59 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 6 (DELIVERED ~65 days ago) — Félix ======
SET @cust := (SELECT customer_id FROM customers WHERE email='felix.d@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='felix.d@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 65 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Hawaiian'),'M',2);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 65 DAY) + INTERVAL 16 MINUTE,
       (NOW() - INTERVAL 65 DAY) + INTERVAL 64 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 7 (DELIVERED ~61 days ago) — Gita ======
SET @cust := (SELECT customer_id FROM customers WHERE email='gita.k@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='gita.k@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 61 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Primavera'),'S',1),
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Margherita'),'M',1);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 61 DAY) + INTERVAL 22 MINUTE,
       (NOW() - INTERVAL 61 DAY) + INTERVAL 70 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 8 (DELIVERED ~55 days ago) — Hugo ======
SET @cust := (SELECT customer_id FROM customers WHERE email='hugo.s@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='hugo.s@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 55 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Diavola'),'M',2);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 55 DAY) + INTERVAL 12 MINUTE,
       (NOW() - INTERVAL 55 DAY) + INTERVAL 58 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 9 (DELIVERED ~50 days ago) — Ines ======
SET @cust := (SELECT customer_id FROM customers WHERE email='ines.m@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='ines.m@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 50 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Veggie Supreme'),'L',1);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 50 DAY) + INTERVAL 17 MINUTE,
       (NOW() - INTERVAL 50 DAY) + INTERVAL 61 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDER 10 (DELIVERED ~45 days ago) — Joris ======
SET @cust := (SELECT customer_id FROM customers WHERE email='joris.d@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='joris.d@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc   := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 45 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas(order_id,pizza_id,size,quantity) VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='BBQ Chicken'),'M',1),
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Hawaiian'),'S',1);
INSERT INTO deliveries(order_id,assigned_to,assigned_at,delivered_at)
SELECT @oid, dz.delivery_person_id,
       (NOW() - INTERVAL 45 DAY) + INTERVAL 20 MINUTE,
       (NOW() - INTERVAL 45 DAY) + INTERVAL 63 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== ORDERS 11–18 (DELIVERED 40..15 days ago) — rotate customers/pizzas ======
-- To keep this script readable, we’ll keep the same pattern with different dates/pizzas.

-- 11
SET @cust := (SELECT customer_id FROM customers WHERE email='alice.j@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='alice.j@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders(customer_id,address_id,placed_at,status,discount_code_id)
VALUES (@cust,@addr, NOW() - INTERVAL 40 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Margherita'),'S',2);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 40 DAY)+INTERVAL 15 MINUTE,(NOW()-INTERVAL 40 DAY)+INTERVAL 55 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 12
SET @cust := (SELECT customer_id FROM customers WHERE email='bert.p@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='bert.p@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 38 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Diavola'),'M',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 38 DAY)+INTERVAL 20 MINUTE,(NOW()-INTERVAL 38 DAY)+INTERVAL 70 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 13
SET @cust := (SELECT customer_id FROM customers WHERE email='chiara.r@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='chiara.r@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 35 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Primavera'),'M',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 35 DAY)+INTERVAL 18 MINUTE,(NOW()-INTERVAL 35 DAY)+INTERVAL 66 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 14
SET @cust := (SELECT customer_id FROM customers WHERE email='daan.v@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='daan.v@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 32 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Funghi'),'L',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 32 DAY)+INTERVAL 22 MINUTE,(NOW()-INTERVAL 32 DAY)+INTERVAL 68 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 15
SET @cust := (SELECT customer_id FROM customers WHERE email='eva.m@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='eva.m@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 29 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Quattro Formaggi'),'S',2);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 29 DAY)+INTERVAL 17 MINUTE,(NOW()-INTERVAL 29 DAY)+INTERVAL 61 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 16
SET @cust := (SELECT customer_id FROM customers WHERE email='felix.d@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='felix.d@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 26 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='BBQ Chicken'),'M',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 26 DAY)+INTERVAL 23 MINUTE,(NOW()-INTERVAL 26 DAY)+INTERVAL 63 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 17
SET @cust := (SELECT customer_id FROM customers WHERE email='gita.k@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='gita.k@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 23 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Veggie Supreme'),'M',1),
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Marinara'),'S',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 23 DAY)+INTERVAL 19 MINUTE,(NOW()-INTERVAL 23 DAY)+INTERVAL 65 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 18
SET @cust := (SELECT customer_id FROM customers WHERE email='hugo.s@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='hugo.s@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 20 DAY,'DELIVERED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Diavola'),'L',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 20 DAY)+INTERVAL 16 MINUTE,(NOW()-INTERVAL 20 DAY)+INTERVAL 60 MINUTE
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- ====== Recent orders (some still in progress) ======

-- 19 (OUT_FOR_DELIVERY ~10 days ago) — Ines
SET @cust := (SELECT customer_id FROM customers WHERE email='ines.m@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='ines.m@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 10 DAY,'OUT_FOR_DELIVERY',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Primavera'),'M',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 10 DAY)+INTERVAL 12 MINUTE,NULL
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 20 (PREPARING ~8 days ago) — Joris
SET @cust := (SELECT customer_id FROM customers WHERE email='joris.d@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='joris.d@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 8 DAY,'PREPARING',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Hawaiian'),'S',2);

-- 21 (PLACED ~6 days ago) — Alice (second address)
SET @cust := (SELECT customer_id FROM customers WHERE email='alice.j@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='alice.j@example.com' ORDER BY a.address_id DESC LIMIT 1);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 6 DAY,'PLACED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Margherita'),'M',1);

-- 22 (PREPARING ~4 days ago) — Bert
SET @cust := (SELECT customer_id FROM customers WHERE email='bert.p@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='bert.p@example.com' ORDER BY a.address_id LIMIT 1);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 4 DAY,'PREPARING',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Diavola'),'M',1);

-- 23 (OUT_FOR_DELIVERY ~2 days ago) — Chiara
SET @cust := (SELECT customer_id FROM customers WHERE email='chiara.r@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='chiara.r@example.com' ORDER BY a.address_id LIMIT 1);
SET @pc := (SELECT postal_code FROM addresses WHERE address_id=@addr);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 2 DAY,'OUT_FOR_DELIVERY',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Marinara'),'L',1);
INSERT INTO deliveries SELECT @oid,dz.delivery_person_id,(NOW()-INTERVAL 2 DAY)+INTERVAL 14 MINUTE,NULL
FROM delivery_zones dz WHERE dz.postal_code=@pc LIMIT 1;

-- 24 (PLACED ~1 day ago) — Daan
SET @cust := (SELECT customer_id FROM customers WHERE email='daan.v@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='daan.v@example.com' ORDER BY a.address_id LIMIT 1);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW() - INTERVAL 1 DAY,'PLACED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Funghi'),'M',1);

-- 25 (PLACED today) — Eva
SET @cust := (SELECT customer_id FROM customers WHERE email='eva.m@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='eva.m@example.com' ORDER BY a.address_id LIMIT 1);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW(),'PLACED',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='Quattro Formaggi'),'M',1);

-- 26 (PREPARING today) — Félix
SET @cust := (SELECT customer_id FROM customers WHERE email='felix.d@example.com');
SET @addr := (SELECT a.address_id FROM addresses a JOIN customers c ON c.customer_id=a.customer_id
              WHERE c.email='felix.d@example.com' ORDER BY a.address_id LIMIT 1);
INSERT INTO orders VALUES (NULL,@cust,@addr,NOW(),'PREPARING',NULL);
SET @oid := LAST_INSERT_ID();
INSERT INTO order_pizzas VALUES
(@oid,(SELECT pizza_id FROM pizzas WHERE name='BBQ Chicken'),'M',1);
