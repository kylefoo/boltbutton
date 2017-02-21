json.extract! product, :id, :name, :slug, :sku, :category_id, :created_at, :updated_at
json.url api_product_url(product, format: :json)