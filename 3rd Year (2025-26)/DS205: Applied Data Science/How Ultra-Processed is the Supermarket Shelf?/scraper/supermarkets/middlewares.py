import time

from scrapy import signals
from scrapy.http import HtmlResponse

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException, WebDriverException

class SupermarketsSpiderMiddleware: 
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the spider middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_spider_input(self, response, spider):
        # Called for each response that goes through the spider
        # middleware and into the spider.

        # Should return None or raise an exception.
        return None

    def process_spider_output(self, response, result, spider):
        # Called with the results returned from the Spider, after
        # it has processed the response.

        # Must return an iterable of Request, or item objects.
        for i in result:
            yield i

    def process_spider_exception(self, response, exception, spider):
        # Called when a spider or process_spider_input() method
        # (from other spider middleware) raises an exception.

        # Should return either None or an iterable of Request or item objects.
        pass

    async def process_start(self, start):
        # Called with an async iterator over the spider start() method or the
        # matching method of an earlier spider middleware.
        async for item_or_request in start:
            yield item_or_request

    def spider_opened(self, spider):
        spider.logger.info("Spider opened: %s" % spider.name)

class SupermarketsDownloaderMiddleware:
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the downloader middleware does not modify the
    # passed objects.

    @classmethod
    def from_crawler(cls, crawler):
        # This method is used by Scrapy to create your spiders.
        s = cls()
        crawler.signals.connect(s.spider_opened, signal=signals.spider_opened)
        return s

    def process_request(self, request, spider):
        # Called for each request that goes through the downloader
        # middleware.

        # Must either:
        # - return None: continue processing this request
        # - or return a Response object
        # - or return a Request object
        # - or raise IgnoreRequest: process_exception() methods of
        #   installed downloader middleware will be called
        return None

    def process_response(self, request, response, spider):
        # Called with the response returned from the downloader.

        # Must either;
        # - return a Response object
        # - return a Request object
        # - or raise IgnoreRequest
        return response

    def process_exception(self, request, exception, spider):
        # Called when a download handler or a process_request()
        # (from other downloader middleware) raises an exception.

        # Must either:
        # - return None: continue processing this exception
        # - return a Response object: stops process_exception() chain
        # - return a Request object: stops process_exception() chain
        pass

    def spider_opened(self, spider):
        spider.logger.info("Spider opened: %s" % spider.name)

class SeleniumMiddleware:
    """
    This middleware uses Selenium to render JavaScript-heavy pages (e.g. rejecting cookies, 
    expanding categories, clicks load more). It returns a HtmlResponse built from the Selenium 
    page source so the spider can parse the fully rendered HTML.
    """
    def __init__(self, timeout=10, headless=True, retry_attempts=5):
        self.driver = None
        self.wait = None
        self.timeout = timeout
        self.headless = headless
        self.retry_attempts = retry_attempts

    @classmethod
    def from_crawler(cls, crawler):
        headless = crawler.settings.getbool("SELENIUM_HEADLESS", True)
        timeout = crawler.settings.getint("SELENIUM_TIMEOUT", 10)
        retry_attempts = crawler.settings.getint("SELENIUM_RETRY_ATTEMPTS", 5)
        mw = cls(timeout=timeout, headless=headless, retry_attempts=retry_attempts)
        crawler.signals.connect(mw.spider_opened, signal=signals.spider_opened)
        crawler.signals.connect(mw.spider_closed, signal=signals.spider_closed)
        return mw

    def spider_opened(self, spider):
        """
        This function creates the browser when the spider starts.
        """
        options = Options()
        # options.add_argument("--headless") # uncomment if needed
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-gpu")
        options.add_argument("--disable-dev-shm-usage")

        try:
            self.driver = webdriver.Chrome(options=options)
            self.wait = WebDriverWait(self.driver, self.timeout)
        except Exception as e:
            pass

    def process_request(self, request, spider):
        """
        This function uses Selenium to fetch the page and perform necessary interactions.
        It returns a `HtmlResponse` so Scrapy will use the rendered HTML.
        """
        try:
            spider.logger.debug(f"Selenium fetching: {request.url}")
            self.driver.get(request.url)

            # rejecting cookies on the starting page 
            if request.url == "https://www.waitrose.com/ecom/shop/browse/groceries":
                try:
                    reject_btn = self.wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, 'button[data-testid="reject-all"]')))
                    self.driver.execute_script("arguments[0].click();", reject_btn)
                except (TimeoutException, NoSuchElementException):
                    pass

                # click the "show all" button for category items
                try:
                    show_all = self.driver.find_element(By.CSS_SELECTOR, "button.expandButton___lC8ny")
                    self.driver.execute_script("arguments[0].click();", show_all)
                except (TimeoutException, NoSuchElementException):
                    pass

            # clicking "Load More" until it disappears on main category pages
            if "/browse/" in request.url and "products" not in request.url and request.url != "https://www.waitrose.com/ecom/shop/browse/groceries":
                while True:
                    try:
                        # waits for button to exist and be clickable (with longer timeout for load more)
                        load_button = WebDriverWait(self.driver, 15).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "button[data-actiontype='load']")))
                        # scroll to center of viewport to avoid sticky header overlap, and waits
                        self.driver.execute_script("arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});", load_button)
                        time.sleep(1)
                        # clicks the load more button and waits before checking for another button
                        self.driver.execute_script("arguments[0].click();", load_button)
                        time.sleep(0.7)
                    except Exception as e:
                        break

            # wait for remaining JavaScript to run
            time.sleep(1)

            # return the rendered page for the spider to parse
            body = str.encode(self.driver.page_source)
            return HtmlResponse(self.driver.current_url, body=body, encoding="utf-8", request=request)

        except WebDriverException as e:
            return None

    def spider_closed(self, spider):
        """
        This function closes the browser when the spider is finished.
        """
        if self.driver:
            self.driver.quit()

