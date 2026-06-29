{{ config(materialized='table') }}

SELECT
    CAST(event_date AS DATE) AS event_date,
    record_type,
    CAST(total_risk_weighted_value_usd AS DOUBLE) AS total_risk_weighted_value_usd
FROM {{ ref('bronze_daily_forecast') }}