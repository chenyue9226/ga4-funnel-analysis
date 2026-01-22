-- GA4 Funnel Analysis (BigQuery)
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Date range: 2020-11-01 to 2021-01-31

--Step 4: Channel grouping
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
    AND event_name IN ('view_item', 'purchase')
),
session_flags AS (
  SELECT
    CONCAT(user_pseudo_id, '-', IFNULL(ga_session_id, '0')) AS session_id,
    ARRAY_AGG(source ORDER BY event_timestamp LIMIT 1)[OFFSET(0)] AS source,
    ARRAY_AGG(medium ORDER BY event_timestamp LIMIT 1)[OFFSET(0)] AS medium,
    MAX(event_name='view_item') AS has_view,
    MAX(event_name='purchase') AS has_purchase
  FROM base
  GROUP BY session_id
),
channel_grouped AS (
  SELECT
    CASE
      WHEN source = '(direct)' AND medium = '(none)' THEN 'Direct'
      WHEN medium = 'organic' THEN 'Organic Search'
      WHEN medium = 'cpc' THEN 'Paid Search'
      WHEN medium = 'referral' THEN 'Referral'
      WHEN source LIKE '%data deleted%' OR source LIKE '%<Other>%' THEN 'Unknown'
      ELSE 'Other'
    END AS channel_group,
    has_view,
    has_purchase
  FROM session_flags
)
SELECT
  channel_group,
  COUNTIF(has_view) AS sessions_view_item,
  COUNTIF(has_purchase) AS sessions_purchase,
  SAFE_DIVIDE(COUNTIF(has_purchase), COUNTIF(has_view)) AS cv_view_to_purchase
FROM channel_grouped
GROUP BY channel_group
ORDER BY sessions_view_item DESC;
