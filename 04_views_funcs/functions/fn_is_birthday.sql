USE mamma_mia;

DROP FUNCTION IF EXISTS fn_is_birthday;
CREATE FUNCTION fn_is_birthday(p_customer_id INT, p_on DATETIME)
RETURNS TINYINT(1)
READS SQL DATA
RETURN EXISTS (
  SELECT 1
  FROM customers c
  WHERE c.customer_id = p_customer_id
    AND DAY(c.birth_date)   = DAY(p_on)
    AND MONTH(c.birth_date) = MONTH(p_on)
);
