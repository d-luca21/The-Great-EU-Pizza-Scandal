USE mamma_mia;

-- === gender column on customers ===
SELECT COUNT(*) INTO @has_col
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME   = 'customers'
  AND COLUMN_NAME  = 'gender';

SET @sql := IF(@has_col = 0,
  "ALTER TABLE customers
     ADD COLUMN gender ENUM('F','M','X') NULL
     COMMENT 'F/M/X or NULL if unknown'",
  "SELECT 'gender already present' AS info");

PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- === index on orders(placed_at) ===
SELECT COUNT(*) INTO @has_idx1
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME   = 'orders'
  AND INDEX_NAME   = 'idx_orders_placed_at';

SET @sql := IF(@has_idx1 = 0,
  "CREATE INDEX idx_orders_placed_at ON orders(placed_at)",
  "SELECT 'idx_orders_placed_at exists' AS info");

PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- === index on addresses(postal_code) (only if missing) ===
SELECT COUNT(*) INTO @has_idx2
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME   = 'addresses'
  AND INDEX_NAME   = 'idx_addresses_postal';

SET @sql := IF(@has_idx2 = 0,
  "CREATE INDEX idx_addresses_postal ON addresses(postal_code)",
  "SELECT 'idx_addresses_postal exists' AS info");

PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;
