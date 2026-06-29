import json
import os
import random
from datetime import datetime, timedelta, timezone
from pathlib import Path

import pandas as pd


# =========================================
# Basic settings
# =========================================

BASE_DIR = Path(__file__).resolve().parents[1]

SOURCE_DATA_DIR = BASE_DIR / "source_data"
LATEST_DIR = SOURCE_DATA_DIR / "latest"
MASTER_DIR = SOURCE_DATA_DIR / "master"
STATE_DIR = SOURCE_DATA_DIR / "state"

LATEST_DIR.mkdir(parents=True, exist_ok=True)
MASTER_DIR.mkdir(parents=True, exist_ok=True)
STATE_DIR.mkdir(parents=True, exist_ok=True)

LATEST_FILE = LATEST_DIR / "exposure_events_latest.csv"
MASTER_FILE = MASTER_DIR / "exposure_events_all.csv"
STATE_FILE = STATE_DIR / "generator_state.json"

# Normal daily run:
# python scripts/generate_daily_exposure_events.py
#
# Historical seed run:
# HISTORICAL_SEED_MODE=true BATCH_SIZE=1000 HISTORICAL_SEED_DAYS=30 python scripts/generate_daily_exposure_events.py

BATCH_SIZE = int(os.getenv("BATCH_SIZE", "5"))

HISTORICAL_SEED_MODE = (
    os.getenv("HISTORICAL_SEED_MODE", "false").lower() == "true"
)

HISTORICAL_SEED_DAYS = int(
    os.getenv("HISTORICAL_SEED_DAYS", "30")
)


# =========================================
# Reference data
# =========================================

locations = [
    {
        "country": "Japan",
        "iso_code": "JPN",
        "region": "Asia",
        "city": "Tokyo",
        "latitude": 35.6762,
        "longitude": 139.6503,
    },
    {
        "country": "United States",
        "iso_code": "USA",
        "region": "North America",
        "city": "Houston",
        "latitude": 29.7604,
        "longitude": -95.3698,
    },
    {
        "country": "United Kingdom",
        "iso_code": "GBR",
        "region": "Europe",
        "city": "London",
        "latitude": 51.5072,
        "longitude": -0.1276,
    },
    {
        "country": "Brazil",
        "iso_code": "BRA",
        "region": "South America",
        "city": "São Paulo",
        "latitude": -23.5558,
        "longitude": -46.6396,
    },
    {
        "country": "Australia",
        "iso_code": "AUS",
        "region": "Oceania",
        "city": "Sydney",
        "latitude": -33.8688,
        "longitude": 151.2093,
    },
    {
        "country": "South Africa",
        "iso_code": "ZAF",
        "region": "Africa",
        "city": "Cape Town",
        "latitude": -33.9249,
        "longitude": 18.4241,
    },
    {
        "country": "India",
        "iso_code": "IND",
        "region": "Asia",
        "city": "Mumbai",
        "latitude": 19.0760,
        "longitude": 72.8777,
    },
    {
        "country": "Mexico",
        "iso_code": "MEX",
        "region": "North America",
        "city": "Mexico City",
        "latitude": 19.4326,
        "longitude": -99.1332,
    },
    {
        "country": "Egypt",
        "iso_code": "EGY",
        "region": "Africa",
        "city": "Cairo",
        "latitude": 30.0444,
        "longitude": 31.2357,
    },
    {
        "country": "France",
        "iso_code": "FRA",
        "region": "Europe",
        "city": "Paris",
        "latitude": 48.8566,
        "longitude": 2.3522,
    },
]

asset_types = [
    "Factory",
    "Warehouse",
    "Office",
    "Energy Site",
    "Retail Site",
]

perils = [
    "Flood",
    "Wildfire",
    "Earthquake",
    "Cyclone",
    "Drought",
]

hazard_score_lookup = {
    ("Tokyo", "Earthquake"): 5,
    ("Tokyo", "Flood"): 3,
    ("Houston", "Flood"): 4,
    ("Houston", "Cyclone"): 4,
    ("London", "Flood"): 3,
    ("São Paulo", "Flood"): 3,
    ("Sydney", "Wildfire"): 5,
    ("Sydney", "Drought"): 4,
    ("Cape Town", "Drought"): 5,
    ("Mumbai", "Flood"): 5,
    ("Mumbai", "Cyclone"): 4,
    ("Mexico City", "Earthquake"): 5,
    ("Cairo", "Drought"): 4,
    ("Paris", "Flood"): 2,
}


# =========================================
# Helper functions
# =========================================

def load_state() -> dict:
    if STATE_FILE.exists():
        with open(STATE_FILE, "r", encoding="utf-8") as file:
            return json.load(file)

    return {
        "run_number": 0,
        "total_rows_generated": 0,
    }


def save_state(state: dict) -> None:
    with open(STATE_FILE, "w", encoding="utf-8") as file:
        json.dump(state, file, indent=4)


def get_hazard_score(city: str, peril: str) -> int:
    return hazard_score_lookup.get(
        (city, peril),
        random.choice([1, 2, 2, 3]),
    )


def create_quote_id(run_number: int, row_number: int) -> str:
    return f"QTE-{run_number:04d}-{row_number:03d}"


def create_policy_id(quote_id: str, bound_flag: int) -> str:
    if bound_flag == 1:
        return quote_id.replace("QTE", "POL")

    return ""


def calculate_quoted_premium(
    insured_value_usd: int,
    hazard_score: int,
    pricing_variant: str,
) -> float:
    base_rate = 0.006
    hazard_loading = hazard_score * 0.0015

    technical_premium = insured_value_usd * (
        base_rate + hazard_loading
    )

    if pricing_variant == "B":
        return round(technical_premium * 0.95, 2)

    return round(technical_premium, 2)


def calculate_expected_loss(
    insured_value_usd: int,
    hazard_score: int,
) -> float:
    risk_factor = hazard_score / 5
    return round(insured_value_usd * risk_factor * 0.02, 2)


def calculate_bound_flag(
    hazard_score: int,
    pricing_variant: str,
) -> int:
    base_probability = 0.45

    if hazard_score >= 4:
        base_probability -= 0.10

    if pricing_variant == "B":
        base_probability += 0.08

    return int(random.random() < base_probability)


def get_generated_timestamp(
    current_timestamp: datetime,
    offset: int,
) -> datetime:
    """
    Normal mode:
    - all rows use today's timestamp.

    Historical seed mode:
    - rows are spread across the previous HISTORICAL_SEED_DAYS days.
    - this gives the forecast model multiple actual dates.
    """

    if not HISTORICAL_SEED_MODE:
        return current_timestamp

    days_back = HISTORICAL_SEED_DAYS - 1 - (
        offset % HISTORICAL_SEED_DAYS
    )

    # Add a small random time within the day so generated timestamps
    # do not all look identical.
    random_seconds = random.randint(0, 86_399)

    historical_date = current_timestamp - timedelta(days=days_back)

    historical_midnight = historical_date.replace(
        hour=0,
        minute=0,
        second=0,
        microsecond=0,
    )

    return historical_midnight + timedelta(seconds=random_seconds)


# =========================================
# Generate batch
# =========================================

state = load_state()

run_number = state["run_number"] + 1
start_row_number = state["total_rows_generated"] + 1

current_timestamp = datetime.now(timezone.utc)

rows = []

for offset in range(BATCH_SIZE):
    row_number = start_row_number + offset

    generated_timestamp = get_generated_timestamp(
        current_timestamp=current_timestamp,
        offset=offset,
    )

    event_date = generated_timestamp.date().isoformat()

    location = random.choice(locations)
    peril = random.choice(perils)
    asset_type = random.choice(asset_types)
    pricing_variant = random.choice(["A", "B"])

    hazard_score = get_hazard_score(
        city=location["city"],
        peril=peril,
    )

    insured_value_usd = random.randrange(
        5_000_000,
        50_000_000,
        500_000,
    )

    bound_flag = calculate_bound_flag(
        hazard_score=hazard_score,
        pricing_variant=pricing_variant,
    )

    quote_id = create_quote_id(
        run_number=run_number,
        row_number=row_number,
    )

    policy_id = create_policy_id(
        quote_id=quote_id,
        bound_flag=bound_flag,
    )

    quoted_premium_usd = calculate_quoted_premium(
        insured_value_usd=insured_value_usd,
        hazard_score=hazard_score,
        pricing_variant=pricing_variant,
    )

    expected_loss_usd = calculate_expected_loss(
        insured_value_usd=insured_value_usd,
        hazard_score=hazard_score,
    )

    rows.append(
        {
            "quote_id": quote_id,
            "policy_id": policy_id,
            "event_date": event_date,
            "generated_timestamp_utc": generated_timestamp.isoformat(),
            "account_name": f"{location['city']} Global Assets Ltd",
            "country": location["country"],
            "iso_code": location["iso_code"],
            "region": location["region"],
            "city": location["city"],
            "latitude": location["latitude"],
            "longitude": location["longitude"],
            "asset_type": asset_type,
            "peril": peril,
            "hazard_score": hazard_score,
            "insured_value_usd": insured_value_usd,
            "pricing_variant": pricing_variant,
            "quoted_premium_usd": quoted_premium_usd,
            "expected_loss_usd": expected_loss_usd,
            "bound_flag": bound_flag,
        }
    )


# =========================================
# Save output files
# =========================================

batch_df = pd.DataFrame(rows)

# Sort by event date so the CSV is easier to inspect
batch_df = batch_df.sort_values(
    by=[
        "event_date",
        "generated_timestamp_utc",
        "quote_id",
    ]
)

# Save latest batch for ADF to ingest
batch_df.to_csv(LATEST_FILE, index=False)

# Append to local master file for easy checking
if MASTER_FILE.exists():
    existing_master_df = pd.read_csv(MASTER_FILE)

    updated_master_df = pd.concat(
        [
            existing_master_df,
            batch_df,
        ],
        ignore_index=True,
    )
else:
    updated_master_df = batch_df

updated_master_df = updated_master_df.drop_duplicates(
    subset=["quote_id"],
    keep="last",
)

updated_master_df = updated_master_df.sort_values(
    by=[
        "event_date",
        "generated_timestamp_utc",
        "quote_id",
    ]
)

updated_master_df.to_csv(MASTER_FILE, index=False)


# =========================================
# Update generator state
# =========================================

state["run_number"] = run_number
state["total_rows_generated"] = (
    start_row_number + BATCH_SIZE - 1
)

save_state(state)


# =========================================
# Print useful output
# =========================================

print(f"Generated {BATCH_SIZE} new rows.")
print(f"Historical seed mode: {HISTORICAL_SEED_MODE}")
print(f"Historical seed days: {HISTORICAL_SEED_DAYS}")
print(f"Latest batch saved to: {LATEST_FILE}")
print(f"Master history saved to: {MASTER_FILE}")
print(f"Run number: {run_number}")

if not batch_df.empty:
    print(f"Earliest event_date: {batch_df['event_date'].min()}")
    print(f"Latest event_date: {batch_df['event_date'].max()}")
    print(f"Unique event_date count: {batch_df['event_date'].nunique()}")