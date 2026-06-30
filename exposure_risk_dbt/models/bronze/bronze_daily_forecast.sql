{{ config(materialized='table') }}

SELECT
    event_date,
    record_type,
    actual_risk_weighted_value_usd,
    rolling_7_day_risk_weighted_value_usd,
    forecast_risk_weighted_value_usd,
    forecast_lower_bound_usd,
    forecast_upper_bound_usd,
    total_risk_weighted_value_usd
FROM databricks_learning_premium.default.gold_daily_forecast_engineering