{{ config(materialized='table') }}

SELECT
    model_name,
    model_status,
    training_row_count,
    test_row_count,
    ROUND(accuracy, 4) AS accuracy,
    ROUND(roc_auc, 4) AS roc_auc
FROM {{ ref('silver_ml_model_metrics') }}