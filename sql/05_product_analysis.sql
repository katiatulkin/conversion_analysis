-- ============================================
-- 05 Product Rating & Sales Analysis
-- ============================================

-- Question:
-- Do product ratings and reviews influence sales performance?

-- Description:
-- This analysis examines the relationship between:
-- - Product ratings (average rating)
-- - Review volume (number of ratings)
-- - Sales performance (revenue and units sold)
--
-- Steps:
-- 1. Aggregate reviews at product level
-- 2. Aggregate sales at product level
-- 3. Categorise products into rating buckets
-- 4. Compare sales performance across rating categories

-- Data Source:
-- Original dataset: Kaggle (E-commerce Customer Behaviour Dataset)
-- Query environment: Google BigQuery (reviews, transactions, products)

WITH reviews_agg AS (
  SELECT
    product_id,
    AVG(rating) AS avg_rating,
    COUNT(rating) AS no_of_ratings
  FROM `katiasprojects.ecom_customer_behavior.reviews`
  GROUP BY product_id
),

sales_agg AS (
  SELECT
    product_id,
    SUM(total_amount) AS revenue,
    SUM(quantity) AS units_sold
  FROM `katiasprojects.ecom_customer_behavior.transactions`
  GROUP BY product_id
),

product_summary AS (
  SELECT
    r.product_id,
    r.avg_rating,

    -- Categorise products into rating buckets
    CASE
      WHEN r.avg_rating >= 1 AND r.avg_rating <= 2 THEN 'Bad'
      WHEN r.avg_rating > 2 AND r.avg_rating <= 3 THEN 'Average'
      WHEN r.avg_rating > 3 AND r.avg_rating <= 4 THEN 'Good'
      WHEN r.avg_rating > 4 THEN 'Excellent'
      ELSE 'No Rating'
    END AS rating_category,

    r.no_of_ratings,
    s.revenue,
    s.units_sold

  FROM reviews_agg r
  LEFT JOIN sales_agg s
    ON s.product_id = r.product_id
)

SELECT
  rating_category,

  -- Number of products in each category
  COUNT(product_id) AS product_count,

  -- Total number of reviews
  SUM(no_of_ratings) AS total_reviews,

  -- Total revenue generated
  SUM(revenue) AS total_revenue,

  -- Total units sold
  SUM(units_sold) AS total_units_sold,

  -- Average revenue per product (key performance metric)
  ROUND(AVG(revenue), 2) AS avg_revenue_per_product

FROM product_summary

GROUP BY rating_category

ORDER BY avg_revenue_per_product DESC;

-- ============================================
-- Insight:
-- Higher-rated products generate greater revenue per product,
-- with 'Excellent'-rated items outperforming lower-rated categories.
-- While mid-tier ('Good') products contribute the most total revenue
-- due to volume, improving product ratings represents a significant
-- opportunity for revenue growth.
-- ============================================
