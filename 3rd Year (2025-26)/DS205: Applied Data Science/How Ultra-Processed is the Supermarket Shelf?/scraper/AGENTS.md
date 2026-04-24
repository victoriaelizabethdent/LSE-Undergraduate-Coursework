###### DS205: Advanced Data Manipulation
<h1 align="center">AI Agent Details and Instructions for Part A: Data Collection</h1>
<h4 align="center">This project has used GitHub Copilot and Claude.ai in the development process.</h4>

## DETAILS OF AI USE
Artificial Intelligence (AI) tools have been used to develop the Scrapy project for Part A: Data Collection. Key uses include:
- The conversion of initial Selenium scraping code into a structured Scrapy project with custom middleware.
- Aiding the extraction of product data (barcodes and categories) from `__NEXT_DATA__` JSON script tags on product pages.
- Assisting with category and subcategory filtering logic to exclude non-food items.
- Informing the data output as JSONL format for incremental saving with the terminal command `-o products.jsonl`.

## COPILOT INSTRUCTIONS
#### Project Overview
This is a two-part web scraping and API project for DS205: Applied Data Science.
- **Part A: Data Collection**: Using a Scrapy project, information is gained about Waitrose products.
- **Part B: API Development**: Using FastAPI service, Waitrose product information is enriched with NOVA classifications.

As GitHub Copilot is being deployed with regard to Part A, the key files are:
- The Spider: [supermarkets/spiders/waitrose.py](supermarkets/spiders/waitrose.py).
- `middlewares.py`: [supermarkets/middlewares.py](supermarkets/middlewares.py).

And data flow is stored in `data/scraped/`.

#### Environment & Setup
This project should **always** use the `food` conda environment:

```
conda activate food
```

#### Code Standards
- **Docstrings**: All complex functions require docstrings explaining what and why it operates as it does.
- **Variable Names**: All variable names should be short yet meaningful and descriptive (e.g., `category_limit` not `cat_lim`)
- **CSS Selectors**: It should prioritise stable selectors, using `data-test` attributes when available.
- **Error Handling**: For Selenium, wrap WebDriver calls in try-except to catch `TimeoutException, Exception`.
- **Output Format**: JSONL (one product per line) for scalability

#### Workflow Notes
- Assume `conda activate food` is active when giving run commands.
- Step-by-Step Development (do not create multiple functions at once).

#### Essential Files Reference

| File | Purpose |
|------|---------|
| [supermarkets/spiders/waitrose.py](supermarkets/spiders/waitrose.py) | The Spider |
| [supermarkets/middlewares.py](supermarkets/middlewares.py) | The Selenium Configuration Code |
| [environment.yml](../environment.yml) | The Conda Environment with All Dependencies |
| [scraper/README.md](README.md) | Overview of Part A: Data Collection |
| [README.md](../README.md) | Summative Project Overview (incl. the conda environment) |
