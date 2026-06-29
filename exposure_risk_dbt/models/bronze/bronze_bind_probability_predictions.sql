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
    premium_rate,
    expected_loss_ratio,
    hazard_score,
    risk_category,
    actual_bound_flag,
    predicted_bind_probability,
    predicted_bound_flag,
    model_name,
    model_status
FROM databricks_learning_premium.default.gold_bind_probability_predictions_engineering