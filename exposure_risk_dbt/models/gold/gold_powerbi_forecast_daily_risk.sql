{{ config(materialized='table') }}

SELECT
    event_date,
    record_type,
    ROUND(actual_risk_weighted_value_usd, 2) AS actual_risk_weighted_value_usd,
    ROUND(rolling_7_day_risk_weighted_value_usd, 2) AS rolling_7_day_risk_weighted_value_usd,
    ROUND(forecast_risk_weighted_value_usd, 2) AS forecast_risk_weighted_value_usd,
    ROUND(forecast_lower_bound_usd, 2) AS forecast_lower_bound_usd,
    ROUND(forecast_upper_bound_usd, 2) AS forecast_upper_bound_usd,
    ROUND(total_risk_weighted_value_usd, 2) AS total_risk_weighted_value_usd
FROM {{ ref('silver_daily_forecast') }}
ORDER BY event_date