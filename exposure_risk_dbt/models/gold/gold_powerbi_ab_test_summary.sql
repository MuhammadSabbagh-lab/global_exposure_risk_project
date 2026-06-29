{{ config(materialized='table') }}

SELECT
    pricing_variant,
    quote_count,
    bound_count,
    ROUND(bind_rate, 4) AS bind_rate,
    ROUND(avg_quoted_premium_usd, 2) AS avg_quoted_premium_usd,
    ROUND(avg_premium_rate, 4) AS avg_premium_rate,
    ROUND(avg_expected_loss_ratio, 4) AS avg_expected_loss_ratio,
    ROUND(total_quoted_premium_usd, 2) AS total_quoted_premium_usd,
    ROUND(total_insured_value_usd, 2) AS total_quoted_value_usd,
    ROUND(bound_insured_value_usd, 2) AS bound_value_usd
FROM {{ ref('silver_pricing_variant_summary') }}
ORDER BY pricing_variant