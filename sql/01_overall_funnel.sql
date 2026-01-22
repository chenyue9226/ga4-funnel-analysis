-- GA4 Funnel Analysis (BigQuery)
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Date range: 2020-11-01 to 2021-01-31

-- Step 1: Overall funnel conversion (session-level)
WITH base AS (
  SELECT
    user_pseudo_id,
    CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING) AS ga_session_id,
    event_name,
    event_timestamp
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'purchase')
),

session_flags AS (
  SELECT
    CONCAT(user_pseudo_id, '-', IFNULL(ga_session_id, '0')) AS session_id,
    MAX(IF(event_name = 'view_item', 1, 0)) AS has_view_item,
    MAX(IF(event_name = 'add_to_cart', 1, 0)) AS has_add_to_cart,
    MAX(IF(event_name = 'begin_checkout', 1, 0)) AS has_begin_checkout,
    MAX(IF(event_name = 'purchase', 1, 0)) AS has_purchase
  FROM base
  GROUP BY session_id
)

SELECT
  COUNT(*) AS sessions_with_funnel_events,
  COUNTIF(has_view_item = 1) AS sessions_view_item,
  COUNTIF(has_add_to_cart = 1) AS sessions_add_to_cart,
  COUNTIF(has_begin_checkout = 1) AS sessions_begin_checkout,
  COUNTIF(has_purchase = 1) AS sessions_purchase,

  SAFE_DIVIDE(COUNTIF(has_add_to_cart = 1), COUNTIF(has_view_item = 1)) AS cv_view_to_cart,
  SAFE_DIVIDE(COUNTIF(has_begin_checkout = 1), COUNTIF(has_add_to_cart = 1)) AS cv_cart_to_checkout,
  SAFE_DIVIDE(COUNTIF(has_purchase = 1), COUNTIF(has_begin_checkout = 1)) AS cv_checkout_to_purchase,
  SAFE_DIVIDE(COUNTIF(has_purchase = 1), COUNTIF(has_view_item = 1)) AS cv_view_to_purchase
FROM session_flags;
