require_relative "./fetch_products"

module Shop
  class FetchProduct
    def call(id)
      raise ArgumentError unless id.is_a?(Integer)

      products = FetchProducts.new.call
      product = products.find { |product| product.id == id }

      raise ProductNotFound unless product

      product
    end
  end
end
