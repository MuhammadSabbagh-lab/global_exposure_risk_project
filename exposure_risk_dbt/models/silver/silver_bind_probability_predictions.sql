{{ config(materialized='table') }}

SELECT
    quote_id,
    policy_id,
    CAST(event_date AS DATE) AS event_date,
    country,
    region,
    city,
    asset_type,
    peril,
    pricing_variant,
    CAST(insured_value_usd AS DOUBLE) AS insured_value_usd,
    CAST(quoted_premium_usd AS DOUBLE) AS quoted_premium_usd,
    CAST(expected_loss_usd AS DOUBLE) AS expected_loss_usd,
    CAST(risk_weighted_value_usd AS DOUBLE) AS risk_weighted_value_usd,
    CAST(premium_rate AS DOUBLE) AS premium_rate,
    CAST(expected_loss_ratio AS DOUBLE) AS expected_loss_ratio,
    CAST(hazard_score AS DOUBLE) AS hazard_score,
    risk_category,
    CAST(actual_bound_flag AS INT) AS actual_bound_flag,
    CAST(predicted_bind_probability AS DOUBLE) AS predicted_bind_probability,
    CAST(predicted_bound_flag AS INT) AS predicted_bound_flag,
    model_name,
    model_status
FROM {{ ref('bronze_bind_probability_predictions') }}