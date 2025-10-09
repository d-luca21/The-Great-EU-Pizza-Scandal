USE mamma_mia;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_validate_and_lock_discount_code $$
CREATE PROCEDURE sp_validate_and_lock_discount_code(
    IN  p_code         VARCHAR(64),
    IN  p_customer_id  INT,
    OUT o_discount_code_id INT,
    OUT o_percent_off  DECIMAL(5,2)
)
MODIFIES SQL DATA
BEGIN
    DECLARE v_single_use   TINYINT(1);
    DECLARE v_redeemed_at  DATETIME;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET o_discount_code_id = NULL, o_percent_off = 0.00;

    SET o_discount_code_id = NULL;
    SET o_percent_off      = 0.00;

    /* lock the row so we can safely mark it redeemed if needed */
    SELECT discount_code_id, percent_off, single_use, redeemed_at
      INTO o_discount_code_id, o_percent_off, v_single_use, v_redeemed_at
    FROM discount_codes
    WHERE code = p_code
    LIMIT 1
    FOR UPDATE;

    IF o_discount_code_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid discount code';
    END IF;

    IF v_single_use = 1 AND v_redeemed_at IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Discount code already redeemed';
    END IF;

    /* for single-use codes, mark as redeemed now (holds the lock) */
    IF v_single_use = 1 THEN
        UPDATE discount_codes
           SET redeemed_at = NOW(),
               redeemed_by_customer = p_customer_id
         WHERE discount_code_id = o_discount_code_id;
    END IF;
END $$
DELIMITER ;
