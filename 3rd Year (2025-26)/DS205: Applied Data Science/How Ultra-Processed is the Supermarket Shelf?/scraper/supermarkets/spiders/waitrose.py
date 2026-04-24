import json
import scrapy

class WaitroseSpider(scrapy.Spider):
    name = "waitrose"
    allowed_domains = ["www.waitrose.com"]
    start_urls = ["https://www.waitrose.com/ecom/shop/browse/groceries"]

    # define categories and subcategories as class attributes so they can be accessed in all methods
    food_categories = ["Beer, Wine & Spirits", "Fresh & Chilled", "Bakery", "Food Cupboard", "Frozen", "Tea, Coffee & Soft Drinks", "Baby & Toddler"]
    other_categories = ["Toiletries, Health & Beauty", "Household", "Home", "Pet", "Baby & Toddler Toiletries", "Baby & Toddler Wipes", "Nappies & Pants", 
        "Bottles & Breast Feeding Accessories", "Baby & Toddler Healthcare", "Baby & Child Toys", "Baby Toys", "Clothing & Laundry", "Ice Cubes",]
    
    def parse(self, response):
        """
        This function parses the start_urls page for category links. SeleniumMiddleware will
        have rejected cookies and expanded categories so the HTML contains all category links.
        NOTE: it excludes top-level non-food categories.
        """
        categories = response.css("li.item___Pcd7n")

        # gaining each category's name and URL to follow in def parse_category, excluding non-food categories
        for category in categories:
            category_name = category.css("span.label___ulw8x::text").get()
            category_href = category.css("a.link___T6ReX.themeGrey___Iukk3.basic___ZmyDf::attr(href)").get()
            if category_name in self.food_categories:
                yield response.follow(category_href, callback=self.parse_category, meta={"category_name": category_name})

    def parse_category(self, response):
        """
        This function parses each category page. SeleniumMiddleware will have clicked 'Load More'
        so the response should contain all product pods from which preliminary information is
        extracted (the product's name, quantity and URL), and the URL is followed in def parse_product.
        """
        products = response.css("article[data-testid='product-pod']")
        
        # gaining each product's name, quantity, and URL to follow in def parse_product
        for product in products:
            product_name = product.css("span.name___STajL.ellipses___dLChK::text").get()
            product_quantity = product.css("[data-testid='product-size']::text").get()
            product_href = product.css("a.nameLink___iKLUD.basic___ZmyDf::attr(href)").get()
            if product_href:
                # the URL will be skipped if it has already been visited
                yield response.follow(product_href, callback=self.parse_product, meta={
                    "product_name": product_name,
                    "product_quantity": product_quantity,                  
                })

    def parse_product(self, response):
        """
        This function extracts product details from the product page. It uses `__NEXT_DATA__` to get 
        further information which can be used to match or find similarproducts from the OpenFoods database, 
        and filters out products that belong to any excluded categories.
        """
        script = response.css('script#__NEXT_DATA__::text').get()

        # further information to be extracted
        brand = None
        barcodes = []
        product_categories = []
        
        if script:
            try:
                data = json.loads(script)
                brand = data.get('props', {}).get('pageProps', {}).get('product', {}).get('brand')
                barcodes = data.get('props', {}).get('pageProps', {}).get('product', {}).get('barCodes', [])
                categories_data = data.get('props', {}).get('pageProps', {}).get('product', {}).get('categories', [])
                product_categories = [category.get('name') for category in categories_data if category.get('name') and category.get('name') != 'Groceries']
            except Exception:
                return
        
        # skips any product if it belongs to an excluded category
        for category in self.other_categories:
            if category in product_categories:
                return

        yield {
            "product_name": response.meta.get("product_name"),
            "product_brand": brand,
            "product_quantity": response.meta.get("product_quantity"),
            "product_barcodes": barcodes,
            "product_categories": product_categories,
            "product_url": response.url,
            
        }

