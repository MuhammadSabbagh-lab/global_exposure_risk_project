{{ config(materialized='table') }}

SELECT
    model_name,
    model_status,
    training_row_count,
    test_row_count,
    CAST(accuracy AS DOUBLE) AS accuracy,
    CAST(roc_auc AS DOUBLE) AS roc_auc
FROM {{ ref('bronze_ml_model_metrics') }}