###### DS205: Advanced Data Manipulation
<h1 align="center">Part B: API Development</h1>
<h3 align="center">What Proportion of Groceries and Food Items Available on a UK Supermarket Website is Ultra-Processed (UPF)? And, for Any Given UPF Item, What is its Closest Item That is Non-UPF?</h3>

### API SETUP
This folder contains the API code used to ... food product data from [Waitrose](https://www.waitrose.com/ecom/shop/browse/groceries). It is organised as follows:

```
api/
├── README.md 
├── enrichment.py      
├── models.py    
└── main.py
```

### ENRICHING PRODUCT DATA WITH NOVA CLASSIFICATION
![NOVA](figures/NOVA.png)

To provide a comprehensive API, Waitrose products were enriched with NOVA classifications from Open Food Facts using a two-stage approach:
1. **Barcode Matching**: direct lookup via product barcodes,
2. **Name-Based Fuzzy Matching**: used when barcodes unavailable or don't return results.
This achieved X% coverage across 3,113 products. Non-matched products lack NOVA data in Open Food Facts database.

Using `thefuzz` package [^1], fuzzy matching was employed to provide a higher rate of product matching on the OpenFoodFactsAPI. It should be available in the `food` conda environment, but can alternatively be run using the following terminal command:
```
pip install thefuzz
```

[^1]: 

