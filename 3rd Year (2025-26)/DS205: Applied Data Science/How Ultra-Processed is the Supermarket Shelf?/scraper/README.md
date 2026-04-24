###### DS205: Advanced Data Manipulation
<h1 align="center">Part A: Data Collection</h1>
<h3 align="center">What Proportion of Groceries and Food Items Available on a UK Supermarket Website is Ultra-Processed (UPF)? And, for Any Given UPF Item, What is its Closest Item That is Non-UPF?</h3>

### SCRAPER SETUP
This folder contains the web scraping code used to collect food product data from [Waitrose](https://www.waitrose.com/ecom/shop/browse/groceries). It is organised as follows:

```
scraper/
├── README.md                # this file
├── AGENTS.md                # details the use of AI throughout the scraper
├── scrapy.cfg
├── __init__.py            
├── add_new_attribute.py     # script which adds the Waitrose ID to each product
└── supermarkets
  └── middlewares.py         # contains Selenium code to render JavaScript
  └── items.py         
  └── settings.py
  └── spiders/         
    └── waitrose.py          # the spider which scrapes information from Waitrose.
    └── __init__.py    
        
```

### HOW THE SCRAPER WORKS
This code uses a Scrapy project, which the `waitrose.py` spider to scrape information from a website. It contains multiple functions:
- **parse(self, response)** finds the link to each category page. 
- **parse_category(self, response)** extracts the name, quantity, and URL for each product.
- **parse_product(self, response)** extracts a barcode and sub-category information for each product.

Additionally, `middlewares.py` renders JavaScript heavy pages. The custom class, SeleniumMiddleware, performs the following:
- On the main browsing page, it rejects cookies and shows all categories.
- On each category’s page, it clicks “Load More” until it disappears, ensuring all products are parsed. 

### HOW TO RUN THE SCRAPER
With an activated `environment.yml` (see [this README.md](https://github.com/lse-ds205/problem-set-1-victoriaelizabethdent/blob/main/README.md)), the following commands should be run in the terminal to ensure that products are written incrementally, rather than being stored in memory until the crawl finishes:

```
cd scraper
```
```
scrapy crawl waitrose -o products.jsonl
```

### HOW TO ACCESS PRODUCT DATA
The output of this Scrapy project is contained in `products.jsonl`, visualised below. This data is also available [here](https://lsecloud-my.sharepoint.com/:u:/g/personal/v_dent_lse_ac_uk/IQBg_sYLVq8vRKTfJF69y9RRAdVJ6nv4gvpfN2LcfHCsHMA?e=V7IPLv).  
```
<this-github-repo>/
├── scraper/
├── api/   
└── data/            
  └── scraped/
    └── products.jsonl            # original, scraped data
    └── products_with_ids.jsonl   # enriched data with Waitrose IDs 
```

### WHAT INFORMATION IS INCLUDED
This scraper gains information on food and drink products from Waitrose. These include food and drinks which fall under the categories “Fresh & Chilled”, “Bakery”, “Food Cupboard”, “Frozen”, “Beer, Wine & Spirits”, “Tea, Coffee & Soft Drinks”, and “Baby & Toddler”. The decision to keep drinks in the data is motivated by the NOVA ultra-processed classification including various liquids, alcoholic beverages, and artificially sweetened beverages [^1]. Each product is a JSON object containing key-value pairs for the following:
- `product_name`: str
- `product_brand`: str
- `product_quantity`: str
- `product_barcodes`: list
- `product_categories`: list
- `product_url`: str

It should be noted that `product_quantity` can return in many forms. As Scrapy filters duplicate requests by default, there is no duplication in the data even though there are 464 duplicates in `product_name`, attributed to products of different size. Moreover, there are 16 duplicate barcodes. These remain in the data as some products have multiple barcodes which can be used to identify matches in the OpenFoods database, and should not cause issue as long as the match is verified with `product_name` or `product_quantity`. 


#### Additional Data
For collaborators needing Waitrose IDs, use `data/scraped/products_with_ids.jsonl`. This contains the original scraped data with an extracted product_id field from the URL. To regenerate:
```
cd scraper
python add_new_attribute.py
```
_NOTE_: `product_id` has a string data type.

### FURTHER DEVELOPMENT
Given the time restriction of this task, there are many ways in which this Scrapy project could be improved:
- Gaining further information on each product could be retrieved (e.g. ingredients, product descriptions) which could aid with finding matching and similar products, answering the key research question.
- Employing `pytest` could assess the duplication in the data, and allow for the issue of duplicated barcodes to be assessed.
- Optimising run-time performance.

### ON PART B: API DEVELOPMENT
Using the information scraped from Waitrose, I have some suggestions for how the specific data collected can be used in Part B:
- As `product_quantity` takes many forms (e.g. “250ml”, “150g”, “5s”, “7s”, “(2kg-3kg)”, “Typical weight 1.8kg”, “8x100g”), this variable can assist in determining more precise matches with products listed in the OpenFoodFacts database.
- As `product_categories` contains multiple sub-categories for a certain product, the second question can be answered through finding non-UPF items based on these (e.g. products under “Stock” or “Filled Pasta” could be filtered and analysed to assess whether they fall outside UPF classifications).

[^1]: Millar, S.R., Harrington, J.M., Perry, I.J. and Phillips, C.M. (2025). Associations Between Ultra-Processed Food and Drink Consumption and Biomarkers of Chronic Low-Grade Inflammation: Exploring the Mediating Role of Adiposity. European Journal of Nutrition, 64(4). doi:https://doi.org/10.1007/s00394-025-03666-1.‌
