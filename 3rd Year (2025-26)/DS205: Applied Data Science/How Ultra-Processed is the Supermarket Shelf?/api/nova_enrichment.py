import json
import time
import requests

import pandas as pd

from tqdm import tqdm
from pathlib import Path
from thefuzz import fuzz
from thefuzz import process

# the Open Food Facts API URL for searching UK supermarket products
SEARCH_URL = "https://world.openfoodfacts.org/cgi/search.pl?"
PRODUCT_URL = "https://world.openfoodfacts.org/api/v2/product"

# declaring User-Agent to avoid being blocked by the API
headers = {
    "User-Agent": (
        "DS205Summative01/1.0 "
        "(https://lse-dsi.github.io/DS205/2025-2026/winter-term/; "
        "V.Dent@lse.ac.uk) "
    )
}

# ── cache setup ───────────────────────────────────────────────────────────────
CACHE_FILE = Path("../data/enriched/openfoodfacts_cache.json")

if CACHE_FILE.exists():
    with open(CACHE_FILE) as f:
        cache = json.load(f)
    print(f"Cache loaded: {len(cache)} barcodes already stored")
else:
    cache = {}
    print("No cache found, starting fresh")

# loading Waitrose product data
with open("../data/scraped/all_products.json", "r") as f:
    products = json.load(f)

# converting to pandas DataFrame for easier manipulation
df_waitrose = pd.DataFrame(products)
print(f"Loaded {len(df_waitrose)} Waitrose products")

# enriching products with NOVA 
df_waitrose["nova_group"] = None

# dictionary to store matches for analysis
match_method = {}

# calling the API for each product to get NOVA group information
CALL_API = True
if CALL_API:
    for idx, row in tqdm(df_waitrose.iterrows(), total=len(df_waitrose)):
        found = False
        name = row["name"]
        brand = row["brand"]
        barcodes = row["barcodes"]
                
        if barcodes:
            for barcode in barcodes:
                barcode_url = f"{PRODUCT_URL}/{barcode}"
                try:
                    # --- check cache before making a request ---
                    if barcode in cache:
                        result = cache[barcode]
                        print(f"  (cache) {name}")
                    else:
                        response = requests.get(barcode_url, headers=headers, timeout=5)
                        time.sleep(1)
                        if response.status_code == 200:
                            result = response.json()
                            # save to cache
                            cache[barcode] = result   
                        else:
                            continue

                    if result.get("status") == 1:
                        nova_group = result.get("product", {}).get("nova_group")
                        if nova_group is not None:
                            df_waitrose.at[idx, "nova_group"] = nova_group
                            found = True
                            match_method[idx] = "barcode"
                            print(f"  ✅ {row['name']}: NOVA {nova_group}")
                            break
                        else:
                            match_method[idx] = "no_nova"
                            print(f"{name}: barcode found but no NOVA")
                    
                except Exception as e:
                    print(f"Error with barcode {barcode} ({name}): {e}")
                    time.sleep(2)

# UNCOMMENT THIS BLOCK TO ENABLE NAME-BASED SEARCH FOR PRODUCTS WITHOUT BARCODE MATCHES (SLOW, USE WITH CAUTION)
        # if not found and name:
        #     if brand and brand.lower() not in name.lower():
        #         search_terms = f"{brand} {name}".replace(" ", "+")
        #     else:
        #         search_terms = name.replace(" ", "+")
        #     url = f"{SEARCH_URL}search_terms={search_terms}&search_simple=1&action=process&json=1"
        #     try:
        #         # --- check cache before making a request ---
        #         if name in cache:
        #             results = cache[name]
        #             print(f"  (cache) name search: {name}")
        #         else:
        #             response = requests.get(url, headers=headers, timeout=20)
        #             if response.status_code == 200:
        #                 results = response.json().get("products", [])
        #                 cache[name] = results  # save to cache
        #             else:
        #                 results = []
        #             time.sleep(10)  # extra wait to respect 10/min search limit
        #         if results:
        #             # use fuzzy matching to find the best match among search results
        #             matches = process.extract(name, [p.get("product_name", "") for p in results], scorer=fuzz.token_set_ratio)
        #             # try matches in order (from best to worst match) until we find one with NOVA data
        #             found = False
        #             for match_name, score in matches:
        #                 if score > 80:  # only consider good matches
        #                     matched_product = next(p for p in results if p.get("product_name") == match_name)
        #                     nova_group = matched_product.get("nova_group")
                            
        #                     if nova_group is not None:  # check if this match has NOVA data
        #                         df_waitrose.at[idx, "nova_group"] = nova_group
        #                         found = True
        #                         match_method[idx] = "name_search"
        #                         print(f"{name}: NOVA {nova_group} (name match, score: {score})")
        #                         break  # found one with NOVA data, stop trying
        #                     else:
        #                         print(f"Match '{match_name}' (score: {score}) has no NOVA data, trying next...")
                
        #     except Exception as e:
        #         print(f"Error with name search for {name}: {e}")
        #         time.sleep(2)             

        # save cache to disk every 50 products
        if idx % 50 == 0:
            with open(CACHE_FILE, "w") as f:
                json.dump(cache, f)

    # final cache save
    with open(CACHE_FILE, "w") as f:
        json.dump(cache, f)
    print("Cache saved.")

    # save enriched dataframe
    df_waitrose.to_json("../data/enriched/all_products_nova.jsonl", orient="records", lines=True, force_ascii=False)
    print(f"Saved enriched dataframe to all_products_nova.jsonl")

# summary statistics on enriching all_products.json with NOVA classifications
total = len(df_waitrose)
barcode_matches = sum(1 for v in match_method.values() if v == "barcode")
# fuzzy_matches = sum(1 for v in match_method.values() if v == "name_search")
no_nova = sum(1 for v in match_method.values() if v == "no_nova")
not_found = total - len(match_method)
total_nova = df_waitrose["nova_group"].notna().sum()

print("\n--- MATCH SUMMARY ---")
print(f"Barcode matches:     {barcode_matches:>5} products ({barcode_matches/total*100:.1f}%)")
print(f"Barcode found but no NOVA:   {no_nova:>5} products ({no_nova/total*100:.1f}%)")
# print(f"Fuzzy matches:       {fuzzy_matches:>5} products ({fuzzy_matches/total*100:.1f}%)")
print(f"Not in database:     {not_found:>5} products ({not_found/total*100:.1f}%)")
print(f"Total NOVA coverage: {total_nova}/{total} ({total_nova/total*100:.1f}%)")