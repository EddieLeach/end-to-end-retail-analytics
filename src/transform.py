from pathlib import Path
import pandas as pd
from extract import extract_orders

PROCESSED_PATH = Path("data/processed/orders_clean.csv")


def transform_orders() -> pd.DataFrame:
    """
    Basic cleaning / standardization.
    Customize this as you refine the project.
    """
    df = extract_orders()

    # Example standard cleaning steps - tweak to fit your columns
    df = df.drop_duplicates()

    # Strip whitespace from string columns
    for col in df.select_dtypes(include="object").columns:
        df[col] = df[col].astype(str).str.strip()

    # Convert dates (adjust column name to your dataset)
    for date_col in ["order_date", "Order Date", "orderdate"]:
        if date_col in df.columns:
            df[date_col] = pd.to_datetime(df[date_col], errors="coerce")

    # Ensure numeric columns (adjust names for your dataset)
    for col in ["Sales", "Profit", "Quantity", "Discount"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    PROCESSED_PATH.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(PROCESSED_PATH, index=False)
    return df


if __name__ == "__main__":
    df_clean = transform_orders()
    print("Cleaned rows:", len(df_clean))
    print("Saved to:", PROCESSED_PATH)
