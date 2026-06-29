{{ config(materialized='table') }}

SELECT
    quote_id,
    policy_id,
    event_date,
    country,
    region,
    city,
    asset_type,
    peril,
    pricing_variant,
    insured_value_usd,
    quoted_premium_usd,
    expected_loss_usd,
    risk_weighted_value_usd,
    hazard_score,
    risk_category,
    actual_bound_flag,
    predicted_bind_probability,
    predicted_bound_flag,
    CASE
        WHEN predicted_bind_probability >= 0.70 THEN 'High bind probability'
        WHEN predicted_bind_probability >= 0.40 THEN 'Medium bind probability'
        ELSE 'Low bind probability'
    END AS predicted_bind_band,
    model_name,
    model_status
FROM {{ ref('silver_bind_probability_predictions') }}
WHERE model_status = 'trained'