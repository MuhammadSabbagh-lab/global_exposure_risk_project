{{ config(materialized='table') }}

SELECT
    pricing_variant,
    quote_count,
    bound_count,
    total_quoted_premium_usd,
    avg_quoted_premium_usd,
    avg_premium_rate,
    avg_expected_loss_ratio,
    total_insured_value_usd,
    bound_insured_value_usd,
    bind_rate
FROM databricks_learning_premium.default.gold_ab_pricing_engineering