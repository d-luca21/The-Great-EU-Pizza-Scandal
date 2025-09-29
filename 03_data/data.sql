INSERT INTO `ingredients`(`name`, `cost_per_unit`, `unit`, `is_meat`, `is_animal_product`) VALUES
('Tomato Sauce', 0.0040, 'ml', 0, 0),
('Dough', 0.0030, 'g', 0, 0),
('Garlic', 0.0080, 'g', 0, 0),
('Oregano', 0.0060, 'g', 0, 0),
('Mozzarella', 0.0130, 'g', 0, 0),
('Vegan Mozzarella', 0.0150, 'g', 0, 0),
('Pepperoni', 0.0180, 'g', 1, 1),
('Mushrooms', 0.0075, 'g', 0, 0),
('Red Onions', 0.0065, 'g', 0, 0),
('Bell Peppers', 0.0068, 'g', 0, 0),
('Black Olives', 0.0085, 'g', 0, 0),
('Basil', 0.0090, 'g', 0, 0),
('Ham', 0.0175, 'g', 1, 1),
('Pineapple', 0.0060, 'g', 0, 0),
('Chicken', 0.0190, 'g', 1, 1),
('Jalapenos', 0.080, 'g', 0, 0),
('BBQ Sauce', 0.0055, 'ml', 0, 0),
('Spinach', 0.0065, 'g', 0, 0),
('Artichokes', 0.0095, 'g', 0, 0);

INSERT INTO `pizzas`(`name`, `active`) VALUES
('Margherita', 1),
('Marinara', 1),
('Funghi', 1),
('Pepperoni', 1),
('Quattro Formaggi', 1),
('Veggie Supreme', 1),
('Hawaiian', 1),
('BBQ Chicken', 1),
('Diavola', 1),
('Primavera', 1),
('Prosciutto e Rucola', 1),
('Bianca', 1);

INSERT INTO `pizza_ingredients`(`pizza_id`, `ingredient_id`, `qty_unit`) VALUES
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Margherita'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Margherita'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 90),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Margherita'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 130),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Margherita'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Basil'), 5),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Marinara'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Marinara'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 110),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Marinara'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Garlic'), 8),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Marinara'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Oregano'), 3),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Funghi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Funghi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 90),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Funghi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 120),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Funghi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mushrooms'), 80),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Funghi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Oregano'), 3),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Pepperoni'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Pepperoni'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 80),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Pepperoni'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 110),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Pepperoni'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Pepperoni'), 70),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Quattro Formaggi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Quattro Formaggi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 60),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Quattro Formaggi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 100),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Quattro Formaggi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Vegan Mozzarella'), 80),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Quattro Formaggi'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Oregano'), 3),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Veggie Supreme'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Veggie Supreme'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 90),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Veggie Supreme'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Vegan Mozzarella'), 120),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Veggie Supreme'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Bell Peppers'), 60),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Veggie Supreme'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Red Onions'), 40),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Veggie Supreme'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Black Olives'), 30),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Veggie Supreme'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mushrooms'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Hawaiian'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Hawaiian'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 80),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Hawaiian'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 110),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Hawaiian'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Ham'), 70),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Hawaiian'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Pineapple'), 60),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'BBQ Chicken'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'BBQ Chicken'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'BBQ Sauce'), 90),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'BBQ Chicken'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 120),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'BBQ Chicken'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Chicken'), 80),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'BBQ Chicken'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Red Onions'), 35),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Diavola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Diavola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 80),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Diavola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 110),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Diavola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Pepperoni'), 80),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Diavola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Jalapenos'), 20),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Primavera'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Primavera'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 90),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Primavera'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Vegan Mozzarella'), 110),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Primavera'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Spinach'), 50),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Primavera'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Artichokes'), 45),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Primavera'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Bell Peppers'), 40),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Prosciutto e Rucola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Prosciutto e Rucola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Tomato Sauce'), 70),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Prosciutto e Rucola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 110),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Prosciutto e Rucola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Ham'), 70),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Prosciutto e Rucola'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Basil'), 6),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Bianca'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Dough'), 250),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Bianca'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Mozzarella'), 140),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Bianca'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Garlic'), 6),
((SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Bianca'), (SELECT `ingredient_id` FROM `ingredients` WHERE `name` = 'Oregano'), 3);

INSERT INTO `drinks`(`name`, `unit_price`, `vegan`) VALUES
('Sparkling Water 500ml', 2.20, 1),
('Still Water 500ml', 2.00, 1),
('Cola 330ml', 2.50, 1),
('Cola Zero 330ml', 2.50, 1),
('Orange Soda 330ml', 2.50, 1),
('Iced Tea 500ml', 3.00, 1),
('Apple Juice 250ml', 2.80, 1),
('Lemonade 400ml', 3.20, 1);

INSERT INTO `desserts`(`name`, `unit_price`, `vegan`) VALUES
('Tiramisu', 4.50, 0),
('Chocolate Brownie', 3.80, 0),
('Vegan Chocolate Mousse', 4.20, 1),
('Panna Cotta', 4.20, 0),
('Fruit Salad', 3.50, 1);

INSERT INTO `customers`(`full_name`, `birth_date`, `email`, `phone`) VALUES
('Lena van Dijk', '1998-03-21', 'lena.vd@example.com', '0612345678'),
('Noah Jansen', '1996-11-02', 'noah.j@example.com', '0611111111'),
('Emma de Boer', '2000-04-18', 'emma.dv@example.com', '0622222222'),
('Lucas Visser', '1992-08-09', 'lucas.v@example.com', '0633333333'),
('Mila Smit', '2001-06-30', 'mila.s@example.com', '0644444444'),
('Daan Bakker', '1995-12-15', 'daan.b@example.com', '0655555555'),
('Sophie Mulder', '1999-01-05', 'sophie.m@example.com', '0666666666'),
('James Meijer', '1994-07-22', 'james.m@example.com', '0677777777'),
('Olivia Bos', '2002-02-10', 'olivia.b@example.com', '0688888888'),
('Finn Dekker', '1998-09-27', 'finn.d@example.com', '0699999999');

INSERT INTO `addresses`(`customer_id`, `line1`, `line2`, `city`, `postal_code`, `country`) VALUES
((SELECT `customer_id` FROM `customers` WHERE `email` = 'lena.vd@example.com'), 'Kerkstraat 12', NULL, 'Maastricht', '6211AA', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'noah.j@example.com'), 'Stationstraat 5', NULL, 'Maastricht', '6212BB', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'emma.dv@example.com'), 'Groene Loper 101', NULL, 'Maastricht', '6221CC', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'lucas.v@example.com'), 'Wycker Grachtstraat 8', NULL, 'Maastricht', '6221DD', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'mila.s@example.com'), 'Markt 1', NULL, 'Maastricht', '6211EB', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'daan.b@example.com'), 'Brusselseweg 420', NULL, 'Maastricht', '6217HB', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'sophie.m@example.com'), 'Tongerselaan 50', NULL, 'Maastricht', '6211LN', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'james.m@example.com'), 'Sint Peterlaan 77', NULL, 'Maastricht', '6211JP', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'olivia.b@example.com'), 'Ceramique Avenue 120', NULL, 'Maastricht', '6221KV', 'Netherlands'),
((SELECT `customer_id` FROM `customers` WHERE `email` = 'finn.d@example.com'), 'Cavaleriestraat 3', NULL, 'Maastricht', '6211NJ', 'Netherlands');

INSERT INTO `delivery_people`(`full_name`, `phone`) VALUES
('Sara Koster', '0610101010'),
('Bjorn Kuipers', '0620202020'),
('Iris Peters', '0630303030');

INSERT INTO `delivery_zones`(`delivery_person_id`, `postal_code`) VALUES
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Sara Koster'), '6211AA'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Sara Koster'), '6211EB'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Bjorn Kuipers'), '6221CC'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Bjorn Kuipers'), '6221DD'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Iris Peters'), '6217HB'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Iris Peters'), '6211JP'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Iris Peters'), '6211LN'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Iris Peters'), '6221KV'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Iris Peters'), '6212BB'),
((SELECT `delivery_person_id` FROM `delivery_people` WHERE `full_name` = 'Iris Peters'), '6211NJ');

INSERT INTO `discount_codes`(`code`, `percent_off`, `single_use`, `redeemed_at`, `redeemed_by_customer`) VALUES
('WELCOME10', 10.00, 0, NULL, NULL),
('STUDENT15', 15.00, 0, NULL, NULL),
('ONETIME25', 25.00, 1, NULL, NULL);

INSERT INTO `orders`(`customer_id`, `address_id`, `placed_at`, `status`, `discount_code_id`) VALUES
(
    (SELECT `customer_id` FROM `customers` WHERE email = 'lena.vd@example.com'),
    (SELECT `address_id` FROM `addresses` WHERE `customer_id` = (SELECT `customer_id` FROM `customers` WHERE `email` = 'lena.vd@example.com') LIMIT 1),
    NOW(), 'PLACED', (SELECT `discount_code_id` FROM `discount_codes` WHERE `code` = 'WELCOME10')
);

INSERT INTO `order_pizzas`(`order_id`, `pizza_id`, `size`, `quantity`) VALUES
(LAST_INSERT_ID(), (SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Margherita'), 'L', 1);

INSERT INTO `order_drinks`(`order_id`, `drink_id`, `quantity`) VALUES
(LAST_INSERT_ID(), (SELECT `drink_id` FROM `drinks` WHERE `name` = 'Cola 330ml'), 2);

INSERT INTO `order_desserts`(`order_id`, `dessert_id`, `quantity`) VALUES
(LAST_INSERT_ID(), (SELECT `dessert_id` FROM `desserts` WHERE `name` = 'Tiramisu'), 1);

INSERT INTO `orders`(`customer_id`, `address_id`, `placed_at`, `status`, `discount_code_id`) VALUES
(
    (SELECT `customer_id` FROM `customers` WHERE `email` = 'noah.j@example.com'),
    (SELECT `address_id` FROM `addresses` WHERE `customer_id` = (SELECT `customer_id` FROM `customers` WHERE `email` = 'noah.j@example.com') LIMIT 1),
    NOW(), 'PREPARING', NULL
);

INSERT INTO `order_pizzas`(`order_id`, `pizza_id`, `size`, `quantity`) VALUES
(LAST_INSERT_ID(), (SELECT `pizza_id` FROM `pizzas` WHERE `name` = 'Pepperoni'), 'M', 2);

INSERT INTO `order_drinks`(`order_id`, `drink_id`, `quantity`) VALUES
(LAST_INSERT_ID(), (SELECT `drink_id` FROM `drinks` WHERE `name` = 'Still Water 500ml'), 1);