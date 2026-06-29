{{ config(materialized='table') }}

SELECT
    country,
    region,
    peril,
    pricing_variant,
    COUNT(DISTINCT quote_id) AS quote_count,
    SUM(actual_bound_flag) AS actual_bound_count,
    ROUND(AVG(predicted_bind_probability), 4) AS avg_predicted_bind_probability,
    ROUND(AVG(actual_bound_flag), 4) AS actual_bind_rate,
    ROUND(SUM(insured_value_usd), 2) AS total_quoted_value_usd,
    ROUND(
        SUM(
            CASE
                WHEN predicted_bind_probability >= 0.70
                THEN insured_value_usd
                ELSE 0
            END
        ),
        2
    ) AS high_probability_quoted_value_usd
FROM {{ ref('silver_bind_probability_predictions') }}
WHERE model_status = 'trained'
GROUP BY
    country,
    region,
    peril,
    pricing_variant