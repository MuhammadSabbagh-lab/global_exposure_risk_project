{{ config(materialized='table') }}

SELECT
    country,
    iso_code,
    region,
    peril,
    COUNT(DISTINCT quote_id) AS quote_count,
    SUM(bound_flag) AS bound_count,
    ROUND(SUM(insured_value_usd), 2) AS total_quoted_value_usd,
    ROUND(SUM(CASE WHEN bound_flag = 1 THEN insured_value_usd ELSE 0 END), 2) AS bound_value_usd,
    ROUND(AVG(hazard_score), 2) AS avg_hazard_score,
    ROUND(SUM(risk_weighted_value_usd), 2) AS risk_weighted_value_usd
FROM {{ ref('silver_exposure_events') }}
GROUP BY
    country,
    iso_code,
    region,
    peril