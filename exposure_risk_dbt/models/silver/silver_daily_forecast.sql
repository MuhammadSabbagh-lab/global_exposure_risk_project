{{ config(materialized='table') }}

SELECT
    CAST(event_date AS DATE) AS event_date,
    record_type,
    CAST(actual_risk_weighted_value_usd AS DOUBLE) AS actual_risk_weighted_value_usd,
    CAST(rolling_7_day_risk_weighted_value_usd AS DOUBLE) AS rolling_7_day_risk_weighted_value_usd,
    CAST(forecast_risk_weighted_value_usd AS DOUBLE) AS forecast_risk_weighted_value_usd,
    CAST(forecast_lower_bound_usd AS DOUBLE) AS forecast_lower_bound_usd,
    CAST(forecast_upper_bound_usd AS DOUBLE) AS forecast_upper_bound_usd,
    CAST(total_risk_weighted_value_usd AS DOUBLE) AS total_risk_weighted_value_usd
FROM {{ ref('bronze_daily_forecast') }}
WHERE event_date IS NOT NULL
  AND record_type IS NOT NULL