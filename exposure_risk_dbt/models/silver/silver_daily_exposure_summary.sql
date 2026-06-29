{{ config(materialized='table') }}

SELECT
    event_date,
    COUNT(DISTINCT quote_id) AS quote_count,
    SUM(bound_flag) AS bound_count,
    ROUND(SUM(insured_value_usd), 2) AS total_quoted_value_usd,
    ROUND(SUM(CASE WHEN bound_flag = 1 THEN insured_value_usd ELSE 0 END), 2) AS bound_value_usd,
    ROUND(SUM(risk_weighted_value_usd), 2) AS risk_weighted_value_usd,
    ROUND(AVG(hazard_score), 2) AS avg_hazard_score,
    ROUND(AVG(expected_loss_ratio), 4) AS avg_expected_loss_ratio,
    ROUND(SUM(bound_flag) / COUNT(DISTINCT quote_id), 4) AS bind_rate
FROM {{ ref('silver_exposure_events') }}
GROUP BY event_date