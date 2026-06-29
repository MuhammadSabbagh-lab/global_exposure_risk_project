{{ config(materialized='table') }}

SELECT
    quote_id,
    policy_id,
    event_date,
    country,
    iso_code,
    region,
    city,
    latitude,
    longitude,
    asset_type,
    peril,
    hazard_score,
    hazard_level,
    risk_category,
    insured_value_usd,
    risk_weighted_value_usd,
    pricing_variant,
    quoted_premium_usd,
    expected_loss_usd,
    expected_loss_ratio,
    bound_flag,
    bound_status
FROM {{ ref('silver_exposure_events') }}