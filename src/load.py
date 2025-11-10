from pathlib import Path
import sqlite3
import pandas as pd

PROCESSED_PATH = Path("data/processed/orders_clean.csv")
DB_PATH = Path("data/retail_analytics.db")


def load_to_sqlite():
    if not PROCESSED_PATH.exists():
        raise FileNotFoundError(
            f"Processed file not found: {PROCESSED_PATH}. Run transform.py first."
        )

    df = pd.read_csv(PROCESSED_PATH)

    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)

    # Write to SQLite table "orders"
    df.to_sql("orders", conn, if_exists="replace", index=False)

    conn.close()
    print(f"Loaded {len(df)} rows into {DB_PATH} (table: orders)")


if __name__ == "__main__":
    load_to_sqlite()
