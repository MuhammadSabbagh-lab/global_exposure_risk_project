{{ config(materialized='table') }}

SELECT
    peril,
    SUM(quote_count) AS quote_count,
    SUM(bound_count) AS bound_count,
    ROUND(SUM(total_quoted_value_usd), 2) AS total_quoted_value_usd,
    ROUND(SUM(bound_value_usd), 2) AS bound_value_usd,
    ROUND(
        SUM(avg_hazard_score * quote_count) / NULLIF(SUM(quote_count), 0),
        2
    ) AS avg_hazard_score,
    ROUND(SUM(risk_weighted_value_usd), 2) AS risk_weighted_value_usd
FROM {{ ref('silver_country_peril_summary') }}
GROUP BY peril
ORDER BY risk_weighted_value_usd DESC