{{ config(materialized='table') }}

SELECT
    quote_id,
    policy_id,
    CAST(event_date AS DATE) AS event_date,
    generated_timestamp_utc,
    account_name,
    country,
    iso_code,
    region,
    city,
    CAST(latitude AS DOUBLE) AS latitude,
    CAST(longitude AS DOUBLE) AS longitude,
    asset_type,
    peril,
    CAST(hazard_score AS DOUBLE) AS hazard_score,
    hazard_level,
    risk_category,
    CAST(insured_value_usd AS DOUBLE) AS insured_value_usd,
    pricing_variant,
    CAST(quoted_premium_usd AS DOUBLE) AS quoted_premium_usd,
    CAST(expected_loss_usd AS DOUBLE) AS expected_loss_usd,
    CAST(bound_flag AS INT) AS bound_flag,
    bound_status,
    CAST(risk_weight AS DOUBLE) AS risk_weight,
    CAST(risk_weighted_value_usd AS DOUBLE) AS risk_weighted_value_usd,
    CAST(premium_rate AS DOUBLE) AS premium_rate,
    CAST(expected_loss_ratio AS DOUBLE) AS expected_loss_ratio,
    event_month
FROM {{ ref('bronze_exposure_events') }}
WHERE quote_id IS NOT NULL
  AND country IS NOT NULL
  AND city IS NOT NULL
  AND latitude IS NOT NULL
  AND longitude IS NOT NULL
  AND peril IS NOT NULL