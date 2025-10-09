# Run from repo root:
#   pwsh .\03_data\seed_orders.ps1
# If Python isn't on PATH, change $python below.

$ErrorActionPreference = "Stop"
$python = "python"
$app = "app/place_order.py"

function Place-Order {
  param(
    [int]$CustomerId,
    [int]$AddressId,
    [string]$Postal,
    [string]$PizzasJson,
    [string]$DrinksJson = "[]",
    [string]$DessertsJson = "[]",
    [string]$DiscountCode = ""
  )

  $args = @(
    $app,
    "--customer-id", $CustomerId.ToString(),
    "--address-id",  $AddressId.ToString(),
    "--postal-code", $Postal,
    "--pizzas", $PizzasJson,
    "--drinks", $DrinksJson,
    "--desserts", $DessertsJson
  )
  if ($DiscountCode -ne "") { $args += @("--discount-code", $DiscountCode) }

  & $python @args
}

Write-Host ">> Seeding 28 demo orders using place_order.py ..."

# Assumes:
# customer_id = address_id = N for N=1..10, postal codes from big_seed
# If your IDs differ, run in MySQL:
#   SELECT c.customer_id, a.address_id, a.postal_code
#   FROM customers c JOIN addresses a USING(customer_id) ORDER BY c.customer_id;

$P = @{
  1 = "6211AA"; 2 = "6211EB"; 3 = "6221CC"; 4 = "6221DD"; 5 = "6217HB";
  6 = "6211JP"; 7 = "6211LN"; 8 = "6221KV"; 9 = "6212BB"; 10 = "6211NJ"
}

# 1–10: a spread of small baskets
Place-Order 1 1  $P[1]  '[{"pizza_id":1,"size":"M","qty":1}]'
Place-Order 2 2  $P[2]  '[{"pizza_id":2,"size":"L","qty":1},{"pizza_id":3,"size":"S","qty":1}]' '[{"drink_id":1,"qty":1}]'
Place-Order 3 3  $P[3]  '[{"pizza_id":4,"size":"M","qty":1}]'                               '[{"drink_id":2,"qty":1}]'  ""               # later we’ll reuse WELCOME10 on others
Place-Order 4 4  $P[4]  '[{"pizza_id":5,"size":"L","qty":1}]'                               '[]'                       '[]' "ONETIME15" # single-use
Place-Order 5 5  $P[5]  '[{"pizza_id":6,"size":"M","qty":1}]'
Place-Order 6 6  $P[6]  '[{"pizza_id":7,"size":"S","qty":2},{"pizza_id":8,"size":"M","qty":1}]' '[{"drink_id":3,"qty":2}]' '[{"dessert_id":1,"qty":1}]'
Place-Order 7 7  $P[7]  '[{"pizza_id":9,"size":"M","qty":1}]'                                '[{"drink_id":5,"qty":1}]'
Place-Order 8 8  $P[8]  '[{"pizza_id":2,"size":"M","qty":1},{"pizza_id":1,"size":"S","qty":1}]'
Place-Order 9 9  $P[9]  '[{"pizza_id":3,"size":"M","qty":2}]'
Place-Order 10 10 $P[10] '[{"pizza_id":4,"size":"L","qty":1},{"pizza_id":5,"size":"S","qty":1}]'

# 11–14: try WELCOME10 (re-usable)
Place-Order 3 3  $P[3]  '[{"pizza_id":1,"size":"M","qty":2}]'  '[]' '[]' "WELCOME10"
Place-Order 2 2  $P[2]  '[{"pizza_id":6,"size":"L","qty":1}]'  '[]' '[]' "WELCOME10"
Place-Order 7 7  $P[7]  '[{"pizza_id":10,"size":"L","qty":1}]' '[]' '[]' "WELCOME10"
Place-Order 8 8  $P[8]  '[{"pizza_id":8,"size":"M","qty":1}]'  '[]' '[]' "WELCOME10"

# 15–16: attempt to reuse ONETIME15 (should fail & rollback once used)
Place-Order 5 5  $P[5]  '[{"pizza_id":7,"size":"M","qty":1}]'  '[]' '[]' "ONETIME15"  # expected fail
Place-Order 9 9  $P[9]  '[{"pizza_id":5,"size":"S","qty":1}]'  '[]' '[]' "ONETIME15"  # expected fail

# 17–28: more variety (no discounts)
Place-Order 1 1  $P[1]  '[{"pizza_id":2,"size":"M","qty":1}]'
Place-Order 2 2  $P[2]  '[{"pizza_id":3,"size":"S","qty":2}]'
Place-Order 3 3  $P[3]  '[{"pizza_id":4,"size":"M","qty":1},{"pizza_id":9,"size":"S","qty":1}]'
Place-Order 4 4  $P[4]  '[{"pizza_id":5,"size":"M","qty":1}]' '[{"drink_id":8,"qty":1}]'
Place-Order 5 5  $P[5]  '[{"pizza_id":6,"size":"L","qty":1}]' '[]' '[{"dessert_id":2,"qty":1}]'
Place-Order 6 6  $P[6]  '[{"pizza_id":7,"size":"S","qty":1}]'
Place-Order 7 7  $P[7]  '[{"pizza_id":8,"size":"M","qty":2}]'
Place-Order 8 8  $P[8]  '[{"pizza_id":9,"size":"L","qty":1}]'
Place-Order 9 9  $P[9]  '[{"pizza_id":10,"size":"M","qty":1}]'
Place-Order 10 10 $P[10] '[{"pizza_id":1,"size":"S","qty":3}]'
Place-Order 1 1  $P[1]  '[{"pizza_id":3,"size":"L","qty":1}]'
Place-Order 2 2  $P[2]  '[{"pizza_id":4,"size":"M","qty":2}]'

Write-Host ">> Done placing orders."
Write-Host ">> Next step (spread over last 3 months & set statuses):  mysql mamma_mia < 03_data\\backdate_and_status.sql"
