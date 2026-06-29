{{ config(materialized='table') }}

SELECT
    event_date,
    record_type,
    total_risk_weighted_value_usd
FROM databricks_learning_premium.default.gold_daily_forecast_engineering