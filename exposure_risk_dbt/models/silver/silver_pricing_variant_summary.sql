{{ config(materialized='table') }}

SELECT
    pricing_variant,
    quote_count,
    bound_count,
    CAST(total_quoted_premium_usd AS DOUBLE) AS total_quoted_premium_usd,
    CAST(avg_quoted_premium_usd AS DOUBLE) AS avg_quoted_premium_usd,
    CAST(avg_premium_rate AS DOUBLE) AS avg_premium_rate,
    CAST(avg_expected_loss_ratio AS DOUBLE) AS avg_expected_loss_ratio,
    CAST(total_insured_value_usd AS DOUBLE) AS total_insured_value_usd,
    CAST(bound_insured_value_usd AS DOUBLE) AS bound_insured_value_usd,
    CAST(bind_rate AS DOUBLE) AS bind_rate
FROM {{ ref('bronze_ab_pricing') }}