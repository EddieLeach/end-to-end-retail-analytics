from pathlib import Path
import pandas as pd

RAW_DATA_PATH = Path("data/raw/orders.csv")


def extract_orders() -> pd.DataFrame:
    """
    Load raw orders dataset from data/raw.
    Adjust RAW_DATA_PATH if your filename is different.
    """
    if not RAW_DATA_PATH.exists():
        raise FileNotFoundError(f"Expected file not found: {RAW_DATA_PATH}")
    df = pd.read_csv(RAW_DATA_PATH)
    return df


if __name__ == "__main__":
    df = extract_orders()
    print("Rows:", len(df))
    print("Columns:", list(df.columns))
