# Screenshot Plan

Use this checklist to make the GitHub repo employer-friendly.

The goal is not to screenshot every small thing. The goal is to prove that the project uses the full modern data stack.

---

## Screenshot naming convention

Save screenshots inside:

```text
screenshots/
```

Use simple numbered filenames:

```text
01_repo_structure.png
02_python_generator.png
03_github_actions.png
04_adf_ingestion_pipeline.png
05_adls_raw_structure.png
06_databricks_notebook.png
07_databricks_tables.png
08_dbt_models.png
09_adf_end_to_end_pipeline.png
10_powerbi_global_overview.png
11_powerbi_peril_analysis.png
12_powerbi_forecast.png
13_powerbi_ab_pricing.png
14_powerbi_ml_bind_probability.png
```

---

## 1. GitHub repo structure

Filename:

```text
01_repo_structure.png
```

Show:

- `scripts/`
- `source_data/`
- `exposure_risk_dbt/`
- `docs/`
- `screenshots/`
- `README.md`

Why this matters:

```text
Shows the project is organised and easy to navigate.
```

---

## 2. Python generator

Filename:

```text
02_python_generator.png
```

Show one of these:

- VS Code with `generate_daily_exposure_events.py`
- terminal showing generator output
- both script and generated CSV

Try to capture:

- `BATCH_SIZE`
- `BACKFILL_DAYS`
- output paths
- generated rows

Why this matters:

```text
Shows Python scripting and an evolving data source.
```

---

## 3. GitHub Actions workflow

Filename:

```text
03_github_actions.png
```

Show:

- workflow YAML
- successful workflow run

Why this matters:

```text
Shows automation and scheduled data generation.
```

This one is optional if you did not finalise GitHub Actions.

---

## 4. ADF raw ingestion pipeline

Filename:

```text
04_adf_ingestion_pipeline.png
```

Show:

- ADF pipeline canvas
- Copy activity
- success status if possible

Why this matters:

```text
Shows Azure Data Factory ingestion from GitHub to ADLS.
```

---

## 5. ADLS raw folder structure

Filename:

```text
05_adls_raw_structure.png
```

Show:

```text
raw/exposure/events/ingestion_date=YYYY-MM-DD/
```

with timestamped CSV files.

Why this matters:

```text
Shows raw files are stored historically, not overwritten.
```

---

## 6. Databricks notebook

Filename:

```text
06_databricks_notebook.png
```

Show:

- notebook name
- Bronze/Silver/Gold code
- successful cell output
- display table if possible

Why this matters:

```text
Shows Databricks, PySpark, Pandas and SQL transformation work.
```

---

## 7. Databricks Unity Catalog tables

Filename:

```text
07_databricks_tables.png
```

Show tables such as:

- `bronze_exposure_events_raw`
- `silver_exposure_events_cleaned`
- `silver_daily_exposure_summary`
- `silver_ab_pricing_summary`
- `silver_bind_probability_predictions`
- `gold_exposure_events_engineering`
- `gold_bind_probability_predictions_engineering`

Why this matters:

```text
Shows medallion architecture outputs.
```

---

## 8. dbt models

Filename:

```text
08_dbt_models.png
```

Show one of:

- dbt model folder in VS Code
- dbt run output
- dbt test output
- Databricks dbt Gold tables

Why this matters:

```text
Shows analytics engineering and tested BI-ready modelling.
```

---

## 9. ADF end-to-end orchestration

Filename:

```text
09_adf_end_to_end_pipeline.png
```

Show:

```text
raw ingestion → Databricks engineering job → dbt job
```

Why this matters:

```text
Shows orchestration of the complete pipeline, not isolated scripts.
```

---

## 10. Power BI Global Exposure Overview

Filename:

```text
10_powerbi_global_overview.png
```

Show:

- map visual
- total quoted value card
- risk-weighted value card
- quote count
- risk by country

Why this matters:

```text
Shows geospatial exposure reporting.
```

---

## 11. Power BI Peril Risk Analysis

Filename:

```text
11_powerbi_peril_analysis.png
```

Show:

- peril bar chart
- average hazard score by peril
- country/peril matrix
- slicers

Why this matters:

```text
Shows risk analysis and business reporting.
```

---

## 12. Power BI Forecasting Trend

Filename:

```text
12_powerbi_forecast.png
```

Show:

- Actual vs Forecast line chart
- 90-day future forecast
- clear Actual/Forecast legend

Why this matters:

```text
Shows trend/forecasting-style analytics.
```

---

## 13. Power BI A/B Pricing Analysis

Filename:

```text
13_powerbi_ab_pricing.png
```

Show:

- bind rate by pricing variant
- average premium by variant
- A/B table
- value cards if present

Why this matters:

```text
Shows experiment-style pricing analysis.
```

---

## 14. Power BI ML Bind Probability

Filename:

```text
14_powerbi_ml_bind_probability.png
```

Show:

- predicted bind probability visuals
- relative commercial bind band
- high-value low-probability quote table
- model accuracy and ROC AUC cards

Why this matters:

```text
Shows machine learning outputs surfaced to business users.
```

---

## Final screenshot order in README

Use this order:

1. architecture diagram
2. Power BI dashboard overview
3. ADF pipeline
4. ADLS raw structure
5. Databricks tables/notebook
6. dbt models/tests
7. ML bind probability dashboard

This order works because employers usually want to see the final outcome first, then the technical evidence behind it.
