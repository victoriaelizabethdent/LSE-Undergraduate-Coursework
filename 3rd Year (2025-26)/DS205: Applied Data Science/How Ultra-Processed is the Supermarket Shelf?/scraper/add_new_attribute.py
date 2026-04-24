import json
import pandas as pd

# loading Waitrose product data
with open("../data/scraped/products.jsonl", "r") as f:
    products = [json.loads(line) for line in f]

# converting to pandas DataFrame for easier manipulation
df = pd.DataFrame(products)

# extract product_id from product_url
df['product_id'] = df['product_url'].apply(
    lambda url: url.split('/')[-1].split('-')[0]
)

# save to NEW file (to preserve the raw data)
products_with_ids = df.to_dict(orient='records')
with open("../data/scraped/products_with_ids.jsonl", "w") as f:
    for product in products_with_ids:
        f.write(json.dumps(product, ensure_ascii=False) + '\n')
