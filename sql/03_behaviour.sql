-- ============================================
-- 03 Behaviour Analysis
-- ============================================

-- Question:
-- What behavioural differences exist between converting and non-converting users?

-- Description:
-- This query compares key engagement metrics between:
-- 1. Users who converted (converted = 1)
-- 2. Users who did not convert (converted = 0)
--
-- Metrics analysed:
-- - Session duration
-- - Pages viewed
-- - Bounce rate
-- - Cart additions

-- Data Source:
-- Original dataset: Kaggle (E-commerce Customer Behaviour Dataset)
-- Query environment: Google BigQuery (katiasprojects.ecom_customer_behavior.sessions)

SELECT
  converted,

  -- Average session duration (in seconds)
  ROUND(AVG(duration_seconds), 2) AS avg_session_duration,

  -- Average number of pages viewed per session
  ROUND(AVG(pages_viewed), 2) AS avg_pages_viewed,

  -- Bounce rate (proportion of sessions that bounced)
  ROUND(AVG(bounced), 2) AS bounce_rate,

  -- Average number of cart additions per session
  ROUND(AVG(cart_additions), 2) AS avg_cart_items

FROM `katiasprojects.ecom_customer_behavior.sessions`

GROUP BY converted

ORDER BY converted DESC;

-- ============================================
-- Insight:
-- Converting users exhibit significantly higher engagement,
-- with longer session durations, more pages viewed, and
-- substantially higher cart activity. Cart additions emerge
-- as the strongest behavioural indicator of purchase intent.
-- ============================================
