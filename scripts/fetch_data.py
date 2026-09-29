"""Download Deutsche Bahn monthly stop data and keep only Hamburg's four main stations.

Source: piebro/deutsche-bahn-data (CC BY 4.0, data by Deutsche Bahn via the Timetables API).
The monthly releases used here are the pre-May-2026 schema (columns `station`, `train_name`,
`is_canceled`, planned/changed arrival and departure times). They are read from a GitHub
mirror of those releases; the current releases live on Hugging Face with a newer schema.

Usage:
    python scripts/fetch_data.py            # Oct 2024 - Sep 2025
    python scripts/fetch_data.py 2025-01 2025-06
"""
import sys
import urllib.request
from pathlib import Path

import pandas as pd

URL = (
    "https://raw.githubusercontent.com/Statophobia/deutsche-bahn-data/main/"
    "monthly_data_releases/data-{month}.parquet"
)
STATIONS = ["Hamburg Hbf", "Hamburg Dammtor", "Hamburg-Altona", "Hamburg-Harburg"]
OUT_DIR = Path(__file__).resolve().parents[1] / "data" / "raw"


def fetch_month(month: str) -> int:
    tmp = OUT_DIR / f"_full_{month}.parquet"
    urllib.request.urlretrieve(URL.format(month=month), tmp)
    df = pd.read_parquet(tmp)
    tmp.unlink()
    hamburg = df[df["station"].isin(STATIONS)]
    if hamburg.empty:
        print(f"{month}: no Hamburg rows in source file ({len(df)} rows total) - skipped")
        return 0
    hamburg.to_parquet(OUT_DIR / f"hamburg_stops_{month}.parquet", index=False, compression="zstd")
    print(f"{month}: kept {len(hamburg):,} of {len(df):,} rows")
    return len(hamburg)


if __name__ == "__main__":
    start, end = (sys.argv[1], sys.argv[2]) if len(sys.argv) == 3 else ("2024-10", "2025-09")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for m in pd.period_range(start, end, freq="M").strftime("%Y-%m"):
        fetch_month(m)
