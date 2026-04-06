-- ============================================
-- 02 Channel & Device Performance Analysis
-- ============================================

-- Question:
-- Which device and channel combinations perform best and worst in terms of conversion?

-- Description:
-- This query calculates:
-- 1. Total sessions by device and channel
-- 2. Sessions with cart additions (high intent)
-- 3. Conversions
-- 4. Session-to-conversion rate
-- 5. Cart-to-conversion rate

-- Data Source:
-- Original dataset: Kaggle (E-commerce Customer Behaviour Dataset)
-- Query environment: Google BigQuery (katiasprojects.ecom_customer_behavior.sessions)

SELECT
  device,
  channel,

  -- Total number of sessions
  COUNT(session_id) AS sessions,

  -- Sessions with at least one cart addition
  SUM(CASE 
        WHEN cart_additions > 0 THEN 1 
        ELSE 0 
      END) AS added_to_cart,

  -- Sessions that resulted in a conversion
  SUM(CASE 
        WHEN converted = 1 THEN 1 
        ELSE 0 
      END) AS converted,

  -- Conversion rate from session → purchase
  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END),
      COUNT(session_id)
    ), 3
  ) AS session_to_conversion_cvr,

  -- Conversion rate from cart → purchase (high intent users)
  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END),
      SUM(CASE WHEN cart_additions > 0 THEN 1 ELSE 0 END)
    ), 3
  ) AS cart_to_conversion_cvr

FROM `katiasprojects.ecom_customer_behavior.sessions`

GROUP BY device, channel

ORDER BY session_to_conversion_cvr DESC;

-- ============================================
-- Insight:
-- Desktop and social channels show the highest conversion efficiency,
-- while mobile organic drives the largest volume but underperforms,
-- representing a key optimisation opportunity.
-- ============================================
