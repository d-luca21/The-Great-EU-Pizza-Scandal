DROP FUNCTION IF EXISTS fn_is_birthday;
CREATE FUNCTION fn_is_birthday(p_customer_id INT, p_on DATETIME)
RETURNS TINYINT(1)
READS SQL DATA
BEGIN
    DECLARE v_birth DATE;
    SELECT birth_date INTO v_birth FROM customers WHERE customer_id = p_customer_id;
    RETURN (DAY(v_birth) = DAY(p_on) AND MONTH(v_birth) = MONTH(p_on));
END;