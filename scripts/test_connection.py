"""
Quick connectivity test — confirms the Python BigQuery client can
authenticate and query the fct_experiment_metrics mart.
Run this before building the full analysis notebook.
"""

import os
from dotenv import load_dotenv
from google.cloud import bigquery

load_dotenv()  # reads .env in the current/parent directory

PROJECT_ID = os.environ["GCP_PROJECT_ID"]
DATASET = os.environ["BQ_DATASET"]
# GOOGLE_APPLICATION_CREDENTIALS is read automatically by the
# google-cloud library once it's set in the environment/.env

client = bigquery.Client(project=PROJECT_ID)

query = f"""
    SELECT *
    FROM `{PROJECT_ID}.{DATASET}.fct_experiment_metrics`
    ORDER BY experiment_variant, engagement_tier
"""

df = client.query(query).to_dataframe()

print(f"Rows returned: {len(df)}")
print(df)