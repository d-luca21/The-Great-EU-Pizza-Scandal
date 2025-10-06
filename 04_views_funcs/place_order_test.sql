INSERT INTO customers(full_name, birth_date, email, phone)
VALUES ('Test Customer', '1999-10-10', 'test@example.com', '0612345678');

INSERT INTO addresses(customer_id, line1, city, postal_code, country)
SELECT customer_id, 'Some Street 1', 'Maastricht', '6211AA', 'NL'
FROM customers
WHERE email = 'test@example.com';

SELECT c.customer_id, a.address_id, a.postal_code
FROM customers c
JOIN addresses a ON a.customer_id = c.customer_id
WHERE c.email = 'test@example.com';