USE mamma_mia;

-- View: one row per driver with last time assigned and number of active (undelivered) orders
CREATE OR REPLACE VIEW v_driver_last_assignment AS
SELECT
  dp.delivery_person_id,
  MAX(d.assigned_at) AS last_assigned_at,
  SUM(CASE WHEN d.delivered_at IS NULL THEN 1 ELSE 0 END) AS active_deliveries
FROM delivery_people dp
LEFT JOIN deliveries d
  ON d.assigned_to = dp.delivery_person_id
GROUP BY dp.delivery_person_id;

-- (Optional helper) list of zones per driver
CREATE OR REPLACE VIEW v_driver_zones AS
SELECT
  dz.delivery_person_id,
  dz.postal_code
FROM delivery_zones dz;
