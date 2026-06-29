{{ config(materialized='table') }}

SELECT
    model_name,
    model_status,
    training_row_count,
    test_row_count,
    accuracy,
    roc_auc
FROM databricks_learning_premium.default.gold_ml_model_metrics_engineering