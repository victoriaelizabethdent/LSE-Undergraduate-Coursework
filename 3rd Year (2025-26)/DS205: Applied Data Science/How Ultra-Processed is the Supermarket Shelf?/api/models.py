from pydantic import BaseModel, Field

# defining data structure for the API
class WaitroseProduct(BaseModel):
    '''A single product scraped from Waitrose, ..% enriched with NOVA classification.'''
    name: str | None = Field(default=None, description="product name as displayed on the Waitrose website, None if not available")
    link: str | None = Field(default=None, description="product link from each category's page on the Waitrose website, None if not available")
    price: str | None = Field(default=None, description="product price from the product's page on the Waitrose website, None if not available")
    size: str | None = Field(default=None, description="product size from the product's page on the Waitrose website, None if not available")
    product_id: str | None = Field(default=None, description="product ID from the product's page on the Waitrose website, None if not available")
    brand: str | None = Field(default=None, description="product brand as displayed on the Waitrose website, None if not available")
    category: str | None = Field(default=None, description="product category as displayed on the Waitrose website, None if not available")
    barcodes: list[str] | None = Field(
        default=None,
        description="product barcode(s) from the product's page on the Waitrose website, None if not available") 
    nova_group: int | None = Field(
        default=None,
        ge=1,
        le=4,
        description="NOVA classification (1-4) from OpenFoodFacts, None if not matched"
    )

    model_config = {
            "json_schema_extra": {
                "examples": [
                    {
                    "name": "GAIL's Seeded Sourdough",
                    "link": "https://www.waitrose.com/ecom/products/gails-seeded-sourdough/820327-744449-744450",
                    "price": "£4.95",
                    "size": "650g",
                    "product_id": "820327",
                    "brand": "Gail's",
                    "category": "bakery",
                    "barcodes": ["5060149574836"],
                    "nova_group": 4,
                }
                ]
            }
        }