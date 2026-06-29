{{ config(materialized='table') }}

SELECT
    event_date,
    record_type,
    ROUND(total_risk_weighted_value_usd, 2) AS total_risk_weighted_value_usd
FROM {{ ref('silver_daily_forecast') }}
ORDER BY event_date