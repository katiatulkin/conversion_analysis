-- ============================================
-- 01 Funnel Analysis
-- ============================================

-- Question:
-- Where do users drop off in the conversion funnel?

-- Description:
-- This query calculates the number of:
-- 1. Total sessions
-- 2. Sessions with at least one cart addition
-- 3. Sessions that resulted in a conversion

-- Data Source:
-- Original dataset: Kaggle (E-commerce Customer Behaviour Dataset)
-- Query environment: Google BigQuery (katiasprojects.ecom_customer_behavior.sessions)

SELECT
  COUNT(session_id) AS sessions,

  -- Count of sessions where users added at least one item to cart
  SUM(CASE 
        WHEN cart_additions > 0 THEN 1 
        ELSE 0 
      END) AS added_to_cart,

  -- Count of sessions that resulted in a conversion
  SUM(CASE 
        WHEN converted = 1 THEN 1 
        ELSE 0 
      END) AS converted

FROM `katiasprojects.ecom_customer_behavior.sessions`;

-- ============================================
-- Insight:
-- A significant drop-off is observed between the
-- cart and conversion stages, indicating potential
-- friction during checkout.
-- ============================================
