-- =====================================================================
-- E-commerce Sales & Customer Analysis (BigQuery SQL)
-- Dataset: bigquery-public-data.thelook_ecommerce (free public data)
-- How to use: open console.cloud.google.com/bigquery (free sandbox works),
-- paste ONE query at a time, click Run, and note the results.
-- Tip: check column names under the dataset's Schema tab if a query errors.
-- Revenue below counts only items that were not Cancelled or Returned.
-- =====================================================================


-- 1. HEADLINE KPIs -----------------------------------------------------
SELECT
  COUNT(DISTINCT order_id)                         AS total_orders,
  COUNT(DISTINCT user_id)                          AS total_customers,
  ROUND(SUM(sale_price), 2)                        AS total_revenue,
  ROUND(SUM(sale_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE status NOT IN ('Cancelled', 'Returned');


-- 2. MONTHLY REVENUE TREND + MONTH-ON-MONTH GROWTH ----------------------
WITH monthly AS (
  SELECT
    DATE_TRUNC(DATE(created_at), MONTH) AS month,
    ROUND(SUM(sale_price), 2)           AS revenue,
    COUNT(DISTINCT order_id)            AS orders
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE status NOT IN ('Cancelled', 'Returned')
  GROUP BY month
)
SELECT
  month, revenue, orders,
  ROUND(SAFE_DIVIDE(revenue - LAG(revenue) OVER (ORDER BY month),
                    LAG(revenue) OVER (ORDER BY month)) * 100, 1) AS revenue_growth_pct
FROM monthly
ORDER BY month;


-- 3. REVENUE, PROFIT AND MARGIN BY PRODUCT CATEGORY ----------------------
SELECT
  p.category,
  COUNT(*)                                        AS items_sold,
  ROUND(SUM(oi.sale_price), 2)                    AS revenue,
  ROUND(SUM(oi.sale_price - p.cost), 2)           AS profit,
  ROUND(SAFE_DIVIDE(SUM(oi.sale_price - p.cost), SUM(oi.sale_price)) * 100, 1) AS profit_margin_pct
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY p.category
ORDER BY revenue DESC
LIMIT 15;


-- 4. TOP 10 BRANDS BY PROFIT ----------------------------------------------
SELECT
  p.brand,
  ROUND(SUM(oi.sale_price), 2)          AS revenue,
  ROUND(SUM(oi.sale_price - p.cost), 2) AS profit
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY p.brand
ORDER BY profit DESC
LIMIT 10;


-- 5. RETURN RATE BY CATEGORY (where do we lose money?) --------------------
SELECT
  p.category,
  COUNT(*)                                                    AS items_ordered,
  COUNTIF(oi.status = 'Returned')                             AS items_returned,
  ROUND(SAFE_DIVIDE(COUNTIF(oi.status = 'Returned'), COUNT(*)) * 100, 1) AS return_rate_pct
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
GROUP BY p.category
HAVING items_ordered > 1000
ORDER BY return_rate_pct DESC
LIMIT 10;


-- 6. WHICH MARKETING CHANNEL BRINGS THE BEST CUSTOMERS? -------------------
SELECT
  u.traffic_source,
  COUNT(DISTINCT u.id)                                         AS customers,
  ROUND(SUM(oi.sale_price), 2)                                 AS revenue,
  ROUND(SAFE_DIVIDE(SUM(oi.sale_price), COUNT(DISTINCT u.id)), 2) AS revenue_per_customer
FROM `bigquery-public-data.thelook_ecommerce.users` u
JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi ON u.id = oi.user_id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY u.traffic_source
ORDER BY revenue DESC;


-- 7. TOP 10 COUNTRIES BY REVENUE ------------------------------------------
SELECT
  u.country,
  COUNT(DISTINCT u.id)         AS customers,
  ROUND(SUM(oi.sale_price), 2) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.users` u
JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi ON u.id = oi.user_id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY u.country
ORDER BY revenue DESC
LIMIT 10;


-- 8. CUSTOMER SEGMENTS: how much revenue comes from repeat buyers? --------
WITH customer AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS orders,
    SUM(sale_price)          AS revenue
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE status NOT IN ('Cancelled', 'Returned')
  GROUP BY user_id
)
SELECT
  CASE WHEN orders = 1 THEN '1. One-time buyer'
       WHEN orders BETWEEN 2 AND 3 THEN '2. Repeat buyer (2-3 orders)'
       ELSE '3. Loyal buyer (4+ orders)' END AS segment,
  COUNT(*)                                   AS customers,
  ROUND(SUM(revenue), 2)                     AS revenue,
  ROUND(SUM(revenue) / SUM(SUM(revenue)) OVER () * 100, 1) AS share_of_revenue_pct
FROM customer
GROUP BY segment
ORDER BY segment;


-- 9. COHORT RETENTION: do customers come back after their first order? ----
WITH valid_orders AS (
  SELECT user_id, DATE_TRUNC(DATE(created_at), MONTH) AS order_month
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status NOT IN ('Cancelled', 'Returned')
),
first_order AS (
  SELECT user_id, MIN(order_month) AS cohort_month
  FROM valid_orders
  GROUP BY user_id
)
SELECT
  f.cohort_month,
  DATE_DIFF(v.order_month, f.cohort_month, MONTH) AS months_since_first_order,
  COUNT(DISTINCT v.user_id)                       AS active_customers
FROM first_order f
JOIN valid_orders v USING (user_id)
WHERE f.cohort_month >= '2022-01-01'
GROUP BY f.cohort_month, months_since_first_order
HAVING months_since_first_order <= 6
ORDER BY f.cohort_month, months_since_first_order;
