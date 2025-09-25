# Business Rules — Mamma Mia’s Pizza (Week 1, Student Write‑Up)

**Goal (Week 1):** describe the business rules that drive our ERD. Prices for pizzas are **computed** (not stored), orders must include pizzas, delivery is assigned by postal code with a driver cooldown, and discounts are applied in a clear order.

---

## 1) Pricing (computed, not stored)
- We **do not** store a `price` on `pizzas`. Price is calculated from ingredients each time.
- **Formula per size**  
  `price(size) = Σ(ingredient.cost_per_unit × pizza_ingredients.qty_unit) × 1.40 (margin) × 1.09 (VAT) × size_multiplier`
- **Size multipliers:** S = 0.80, M = 1.00, L = 1.30.
- We round customer-facing prices to **€0.01**.
- **Cheapest pizza definition (used for birthday):** compare each ordered pizza’s **computed size price before discounts**; the lowest is “cheapest.” If there is a tie, we take the first one in the order list.
- **Cheapest drink definition:** same idea, using the stored `unit_price` on drinks.

## 2) Menu & dietary labels
- **Vegetarian:** the pizza has **no ingredient** where `is_meat = 1`.
- **Vegan:** the pizza has **no ingredient** where `is_meat = 1` **and** no ingredient where `is_animal_product = 1` (e.g., cheese, eggs).
- Drinks and desserts store their own `unit_price` and a `vegan` flag.

## 3) Customers & addresses (data quality)
- `customers.email` is **UNIQUE**.
- `birth_date` must indicate **age ≥ 10** at the time of creation.
- A customer can have **many** `addresses` (1→N); each `order` references **exactly one** delivery address.

## 4) Orders & order items
- An order must contain **at least one pizza**; drinks and/or desserts are optional.
- Order status lifecycle: `PLACED → PREPARING → OUT_FOR_DELIVERY → DELIVERED` (or `CANCELLED`).
- `placed_at` is set when the order is created.
- Order line quantities must be **> 0**; pizza line also stores a **size** (`S`,`M`,`L`).

## 5) Discounts (clear stacking order)
Apply discounts **in this exact order**:
1. **Birthday (day‑of, month/day match on server date):**
   - 1 **cheapest pizza free** (see definition above)
   - **+ 1 drink free** (the cheapest drink on the order)
2. **Loyalty:** once a customer has purchased **≥ 10 pizzas** (lifetime count), apply **10% off** the **remaining pizza subtotal**.
3. **Discount code:** `discount_codes.code` is unique; if `single_use = 1`, it can be redeemed **once** (we set `redeemed_at` and `redeemed_by_customer`). Apply `percent_off` to the **post‑loyalty subtotal**.
- The **final total cannot be negative**.
- If multiple discounts would apply to the exact same item, the earlier rule in the list wins (the later ones apply to whatever subtotal remains).

## 6) Delivery & assignment
- Each `delivery_person` covers one or more postal codes through `delivery_zones` (1→N).
- Each order has exactly **one** row in `deliveries` (PK = `order_id`) with `assigned_to` → `delivery_people.delivery_person_id`.
- **Availability rule:** a driver is available if they have **no undelivered orders** and their last `delivered_at` is **> 30 minutes** ago.
- If no driver covers the customer’s postal code (or is available), the order cannot move to `OUT_FOR_DELIVERY`.

## 7) Integrity constraints (schema + logic)
- `ingredients.cost_per_unit > 0`.
- `pizza_ingredients.qty_unit > 0`; all order line `quantity > 0`.
- `discount_codes.code` is **UNIQUE**; `customers.email` is **UNIQUE**.
- `orders.status` and `order_pizzas.size` use **ENUM**s.
- Vegetarian/vegan labels are **derived from ingredients** (we do not store redundant flags on `pizzas`).

## 8) Foreign‑key behavior (matches the ERD)
- `addresses.customer_id → customers.customer_id`: **ON UPDATE CASCADE**, **ON DELETE CASCADE**.
- `orders.customer_id → customers.customer_id`: **ON UPDATE CASCADE**, **ON DELETE RESTRICT**.
- `orders.address_id → addresses.address_id`: **ON UPDATE CASCADE**, **ON DELETE RESTRICT**.
- `orders.discount_code_id → discount_codes.discount_code_id`: **ON UPDATE CASCADE**, **ON DELETE SET NULL**.
- `pizza_ingredients.pizza_id → pizzas.pizza_id`: **ON UPDATE CASCADE**, **ON DELETE CASCADE**.
- `pizza_ingredients.ingredient_id → ingredients.ingredient_id`: **ON UPDATE CASCADE**, **ON DELETE RESTRICT**.
- `order_pizzas.order_id → orders.order_id`: **ON UPDATE CASCADE**, **ON DELETE CASCADE**.
- `order_pizzas.pizza_id → pizzas.pizza_id`: **ON UPDATE CASCADE**, **ON DELETE RESTRICT**.
- `order_drinks.order_id → orders.order_id`: **ON UPDATE CASCADE**, **ON DELETE CASCADE**.
- `order_drinks.drink_id → drinks.drink_id`: **ON UPDATE CASCADE**, **ON DELETE RESTRICT**.
- `order_desserts.order_id → orders.order_id`: **ON UPDATE CASCADE**, **ON DELETE CASCADE**.
- `order_desserts.dessert_id → desserts.dessert_id`: **ON UPDATE CASCADE**, **ON DELETE RESTRICT**.
- `discount_codes.redeemed_by_customer → customers.customer_id`: **ON UPDATE CASCADE**, **ON DELETE SET NULL**.
- `delivery_zones.delivery_person_id → delivery_people.delivery_person_id`: **ON UPDATE CASCADE**, **ON DELETE CASCADE**.
- `deliveries.order_id → orders.order_id`: **ON UPDATE CASCADE**, **ON DELETE CASCADE**.
- `deliveries.assigned_to → delivery_people.delivery_person_id`: **ON UPDATE CASCADE**, **ON DELETE RESTRICT**.

## 9) Transactions (preview for later weeks)
- **Placing an order is atomic.** We insert the order + all lines, compute prices, apply discounts in order, optionally mark a discount code as redeemed, and assign a driver. If **any** step fails (invalid code, no available driver, constraint violation), we **ROLLBACK** the transaction and nothing is saved.

## 10) Assumptions (kept small and realistic)
- Currency is **EUR**; VAT is **9%**; margin is **40%** (both configurable later).
- Birthday check uses **month/day** in the server’s timezone.
- Time fields are stored as `DATETIME` (UTC can be added later if needed).

---

**File name to submit:** `business_rules.md`  
**Folder:** `eu-pizza-system/01_erd/`  
(If your teacher prefers PDF: export this Markdown to `business_rules.pdf` and submit it with your ERD image.)
