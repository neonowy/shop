module Shop
  class AddToBasket
    def initialize(params)
      @product_id = params.fetch("product_id").to_i
      @quantity = params.fetch("quantity").to_i

      @product = FetchProduct.new.call(@product_id)
    end

    def call
      BASKET.add(@product, @quantity)
    end
  end
end
