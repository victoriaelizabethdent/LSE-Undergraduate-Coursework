###### DS205: Advanced Data Manipulation
<h1 align="center">Contributing Guidelines</h1>

### CODE STANDARDS
- All functions should have descriptive docstrings.
- All variable names should be meaningful and descriptive (e.g., `category_name` not `cat`).
- Utilise debugging statements (e.g., `print`, `logger.info`) to check the output before committing.
- Add comments for long functions and complex logic (e.g., try/excepts, exclusion filters, duplicate detection).

### CODE ORGANISATION PRACTICES
- All spider logic is in `waitrose.py`.
- All Selenium interactions are in `middlewares.py`.
- Update and document all dependencies in `environment.yml`
- Both Part A and Part B should have an up-to-date `README.md`.
- Any commits to the repository should be as localised as possible (i.e., avoid using `git add .`).

### GITHUB WORKFLOW CONVENTIONS
- All scraper development has been carried out in the `scraper/` directory.
- The scraper should be run with `scrapy crawl waitrose -o products.jsonl`, although this is not advised due to a long run time.
  - Using `CLOSESPIDER_ITEMCOUNT = 50` at the end of the command above limits the spider, and so this could be used also.
- Use descriptive commit messages (e.g., `git commit -m "added barcode duplicate detection"` not `git commit -m "update"`).

### AI TOOL USAGE GUIDELINES
For guidelines on using AI assistants, see [AGENTS.md](scraper/AGENTS.md).
