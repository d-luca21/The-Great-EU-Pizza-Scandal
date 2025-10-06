CREATE OR REPLACE VIEW v_driver_last_assignment AS
SELECT
    dp.delivery_person_id,
    MAX(d.assigned_at) AS last_assigned_at,
    SUM(d.delivered_at IS NULL) AS active_deliveries
FROM delivery_people dp
LEFT JOIN deliveries d ON d.assigned_to = dp.delivery_person_id
GROUP BY dp.delivery_person_id;

-- Query template to choose a driver for a given postal code:
-- Replace :postal_code with bound parameter.
SELECT dz.delivery_person_id
FROM delivery_zones dz
JOIN v_driver_last_assignment v ON v.delivery_person_id = dz.delivery_person_id
WHERE dz.postal_code = :postal_code
AND v.active_deliveries = 0
AND(v.last_assigned_at IS NULL OR v.last_assigned_at <= (NOW() - INTERVAL 30 MINUTE))
ORDER BY
    COALESCE(v.last_assigned_at, '1970-01-01 00:00:00') ASC,
    dz.delivery_person_id ASC
LIMIT 1;