import os
import json
import pandas as pd

from thefuzz import fuzz
from thefuzz import process
from models import WaitroseProduct
from fastapi import FastAPI, HTTPException

# app setup
def __is_running_on_nuvolos():
    """
    if running from Nuvolos Cloud, there will be an environment 
    variable called HOSTNAME which starts with 'nv-'.
    """
    hostname = os.getenv("HOSTNAME")
    return hostname is not None and hostname.startswith("nv-")

if __is_running_on_nuvolos():
    app = FastAPI(
        root_path="/proxy/8000/",
        title="Waitrose Product API",
        description="Waitrose products enriched with NOVA classifications from OpenFoodFacts.",)
else:
    app = FastAPI(
        title="Waitrose Product API",
        description="Waitrose products enriched with NOVA classifications from OpenFoodFacts.")

# loading enriched product data
df = pd.read_json("../data/enriched/all_products_nova.jsonl", lines=True, dtype={"product_id": str})
df["nova_group"] = df["nova_group"].astype(object).where(df["nova_group"].notna(), None)
products_data = df.to_dict(orient="records")
print(f"✅ Loaded {len(products_data)} products")

# pre-filter products by NOVA group at startup for faster lookups
nova1_products = [p for p in products_data if p.get("nova_group") == 1]
nova2_products = [p for p in products_data if p.get("nova_group") == 2]
nova3_products = [p for p in products_data if p.get("nova_group") == 3]
nova4_products = [p for p in products_data if p.get("nova_group") == 4]

# ENDPOINT: return all products available in the API, optionally filtered by NOVA group (JSON)
@app.get("/products",
    summary="all Waitrose products, optionally filtered by NOVA group",
    description="returns a list of Waitrose products, optionally filtered by NOVA group")
def filter_by_nova(nova_group: int | None = None) -> list[WaitroseProduct]:
    """
    This function filters return all products available in the API, optionally filtered by NOVA group, 
    provided by the user as a query parameter, e.g., /products?nova_group=4 returns all ultra-processed products.
    """
    if nova_group is not None and nova_group not in [1, 2, 3, 4]:
        raise HTTPException(status_code=400, detail="nova_group must be 1, 2, 3, or 4")
    results = [p for p in products_data if nova_group is None or p.get("nova_group") == nova_group]
    return [WaitroseProduct(**p) for p in results]

# ENDPOINT: return a single product with its NOVA classification
@app.get("/products/{id}",
    summary="a single Waitrose product, based on product ID",
    description="returns a single product with its NOVA classification, based on the product ID.")
def get_product_by_id(id: str) -> WaitroseProduct:
    '''
    This function returns a single product with its NOVA classification,
    based on the product ID provided in the URL path (as it can be used to find barcode and name matches).
    '''
    for p in products_data:
        if str(p.get("product_id")) == id:
            try:
                return WaitroseProduct(**p)
            except Exception as e:
                raise HTTPException(status_code=500, detail=f"Error parsing product: {e}")
    raise HTTPException(status_code=404, detail=f"Product '{id}' not found")

# ENDPOINT: for a given UPF product, find the closest non-UPF alternative
@app.get("/products/{id}/alternatives",
    summary="the closest non-processed alternative to a product (identified by product ID)",
    description="for a given processed product (NOVA 2-4), returns the top 3 closest alternatives starting with NOVA 1, then 2, then 3. returns 400 if product is already NOVA 1 or has no NOVA classification.")
def get_alternatives(id: str) -> dict:
    # find the requested product by product ID
    next((p for p in products_data if str(p.get("product_id")) == id), None)
    if product is None:
        raise HTTPException(status_code=404, detail=f"Product '{id}' not found by ID")
    nova = product.get("nova_group")
    if nova == 1:
        raise HTTPException(status_code=400, detail="Product is already unprocessed (NOVA 1) — no less-processed alternative exists.")
    if nova is None:
        raise HTTPException(status_code=400, detail="Product has no NOVA classification — cannot find alternatives.")

    # fill up to 3 alternatives, trying NOVA 1 first, then 2, then 3
    alternatives = []
    for pool in [nova1_products, nova2_products, nova3_products]:
        if len(alternatives) >= 3 or not pool:
            break
        names = [p.get("name", "") for p in pool]
        matches = process.extract(product["name"], names, scorer=fuzz.token_set_ratio, limit=3 - len(alternatives))
        for match_name, score in matches:
            match_idx = names.index(match_name)
            alternatives.append({
                "product": WaitroseProduct(**pool[match_idx]),
                "match_score": score,
            })

    if not alternatives:
        raise HTTPException(status_code=404, detail="No less-processed alternatives found.")

    return {
        "query": WaitroseProduct(**product),
        "query_nova_group": nova,
        "alternatives": alternatives,
    }