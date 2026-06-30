# Power BI DAX Measures

This document lists the DAX measures and calculated columns used in the Power BI dashboard.

---

## Core KPI measures

### Total Quoted Value

```DAX
Total Quoted Value =
SUM(gold_powerbi_global_exposure_map[insured_value_usd])
```

Format:

```text
Currency
```

---

### Total Risk-Weighted Value

```DAX
Total Risk-Weighted Value =
SUM(gold_powerbi_global_exposure_map[risk_weighted_value_usd])
```

Format:

```text
Currency
```

---

### Quote Count

```DAX
Quote Count =
DISTINCTCOUNT(gold_powerbi_global_exposure_map[quote_id])
```

Format:

```text
Whole number
```

---

### Bound Quote Count

```DAX
Bound Quote Count =
SUM(gold_powerbi_global_exposure_map[bound_flag])
```

Format:

```text
Whole number
```

---

### Overall Bind Rate

```DAX
Overall Bind Rate =
DIVIDE(
    [Bound Quote Count],
    [Quote Count]
)
```

Format:

```text
Percentage
```

---

## Pricing measures

### Average Premium Rate

```DAX
Average Premium Rate =
AVERAGE(gold_powerbi_ab_test_summary[avg_premium_rate])
```

Format:

```text
Percentage
```

---

### Average Expected Loss Ratio

```DAX
Average Expected Loss Ratio =
AVERAGE(gold_powerbi_ab_test_summary[avg_expected_loss_ratio])
```

Format:

```text
Percentage
```

---

## ML measures

### Average Predicted Bind Probability

```DAX
Average Predicted Bind Probability =
AVERAGE(gold_powerbi_bind_probability_predictions[predicted_bind_probability])
```

Format:

```text
Percentage
```

---

## Calculated columns

### Relative Commercial Bind Band

Create this as a calculated column, not a measure.

```DAX
Relative Commercial Bind Band =
VAR CurrentProbability =
    gold_powerbi_bind_probability_predictions[predicted_bind_probability]

VAR HighThreshold =
    PERCENTILEX.INC(
        ALL(gold_powerbi_bind_probability_predictions),
        gold_powerbi_bind_probability_predictions[predicted_bind_probability],
        0.67
    )

VAR MediumThreshold =
    PERCENTILEX.INC(
        ALL(gold_powerbi_bind_probability_predictions),
        gold_powerbi_bind_probability_predictions[predicted_bind_probability],
        0.33
    )

RETURN
SWITCH(
    TRUE(),
    CurrentProbability >= HighThreshold, "High commercial bind potential",
    CurrentProbability >= MediumThreshold, "Medium commercial bind potential",
    "Low commercial bind potential"
)
```

Why column, not measure:

```text
This logic needs to classify each quote row by comparing its predicted probability against the wider distribution.
```

---

## Formatting rules

| Field type | Recommended format |
|---|---|
| Values/premiums | Currency |
| Rates/probabilities | Percentage |
| Counts | Whole number |
| Dates | Date only |
| Latitude/longitude | Do not summarize |
