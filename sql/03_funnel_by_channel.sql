-- GA4 Funnel Analysis (BigQuery)
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Date range: 2020-11-01 to 2021-01-31

-- Step 3.5: Funnel by channel (view -> cart -> checkout -> purchase)
WITH base AS (
  SELECT
    user_pseudo_id,
    CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING) AS ga_session_id,
    event_name,
    event_timestamp,
    COALESCE(traffic_source.source, '(direct)') AS source,
    COALESCE(traffic_source.medium, '(none)') AS medium
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'purchase')
),

session_flags AS (
  SELECT
    CONCAT(user_pseudo_id, '-', IFNULL(ga_session_id, '0')) AS session_id,
    ARRAY_AGG(CONCAT(source, ' / ', medium) ORDER BY event_timestamp LIMIT 1)[OFFSET(0)] AS channel,

    MAX(IF(event_name = 'view_item', 1, 0)) AS has_view,
    MAX(IF(event_name = 'add_to_cart', 1, 0)) AS has_cart,
    MAX(IF(event_name = 'begin_checkout', 1, 0)) AS has_checkout,
    MAX(IF(event_name = 'purchase', 1, 0)) AS has_purchase
  FROM base
  GROUP BY session_id
)

SELECT
  channel,
  COUNTIF(has_view = 1) AS s_view,
  COUNTIF(has_cart = 1) AS s_cart,
  COUNTIF(has_checkout = 1) AS s_checkout,
  COUNTIF(has_purchase = 1) AS s_purchase,

  SAFE_DIVIDE(COUNTIF(has_cart = 1), COUNTIF(has_view = 1)) AS cv_view_to_cart,
  SAFE_DIVIDE(COUNTIF(has_checkout = 1), COUNTIF(has_cart = 1)) AS cv_cart_to_checkout,
  SAFE_DIVIDE(COUNTIF(has_purchase = 1), COUNTIF(has_checkout = 1)) AS cv_checkout_to_purchase,
  SAFE_DIVIDE(COUNTIF(has_purchase = 1), COUNTIF(has_view = 1)) AS cv_view_to_purchase
FROM session_flags
GROUP BY channel
HAVING s_view >= 500
ORDER BY s_view DESC
LIMIT 30;
