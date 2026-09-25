"""
Generate synthetic B2B SaaS account data for the
SaaS Experimentation & Value Benchmark Engine project.

This data is entirely synthetic and is clearly labeled as such
in the project README. It exists only to give the dbt models
something to join against real experiment data (e.g. Cookie Cats).

Usage:
    python generate_accounts.py
Output:
    raw_accounts.csv  (in the same folder as this script)
"""

import csv
import random
from datetime import date, timedelta

random.seed(42)  # reproducible output

NUM_ACCOUNTS = 400

INDUSTRIES = [
    "Retail", "E-commerce", "Financial Services", "Healthcare",
    "Technology", "Media & Entertainment", "Travel & Hospitality",
    "Manufacturing", "Education", "Telecommunications",
]

# ARR tiers with rough weights so the distribution isn't uniform
# (more small/mid accounts than enterprise, like a real book of business)
ARR_TIERS = [
    ("SMB", 0.45),
    ("Mid-Market", 0.35),
    ("Enterprise", 0.20),
]

START_DATE = date(2021, 1, 1)
END_DATE = date(2026, 9, 1)


def weighted_tier():
    tiers, weights = zip(*ARR_TIERS)
    return random.choices(tiers, weights=weights, k=1)[0]


def random_onboarding_date():
    delta_days = (END_DATE - START_DATE).days
    return START_DATE + timedelta(days=random.randint(0, delta_days))


def generate_rows(n):
    rows = []
    for i in range(1, n + 1):
        account_id = f"ACC-{i:05d}"
        industry = random.choice(INDUSTRIES)
        arr_tier = weighted_tier()
        onboarding_date = random_onboarding_date()
        rows.append({
            "account_id": account_id,
            "industry": industry,
            "arr_tier": arr_tier,
            "onboarding_date": onboarding_date.isoformat(),
        })
    return rows


def main():
    rows = generate_rows(NUM_ACCOUNTS)
    fieldnames = ["account_id", "industry", "arr_tier", "onboarding_date"]

    with open("raw_accounts.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Wrote {len(rows)} synthetic accounts to raw_accounts.csv")


if __name__ == "__main__":
    main()