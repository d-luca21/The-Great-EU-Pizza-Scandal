USE mamma_mia;

ALTER TABLE ingredients       ADD CONSTRAINT chk_ing_cost  CHECK (cost_per_unit > 0);
ALTER TABLE pizza_ingredients ADD CONSTRAINT chk_qty_unit  CHECK (qty_unit > 0);
ALTER TABLE order_pizzas      ADD CONSTRAINT chk_op_qty    CHECK (quantity > 0);
ALTER TABLE order_drinks      ADD CONSTRAINT chk_od_qty    CHECK (quantity > 0);
ALTER TABLE order_desserts    ADD CONSTRAINT chk_oe_qty    CHECK (quantity > 0);
ALTER TABLE discount_codes    ADD CONSTRAINT chk_percent   CHECK (percent_off BETWEEN 0 AND 100);
