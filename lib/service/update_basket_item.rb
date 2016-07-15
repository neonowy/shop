module Shop
  class UpdateBasketItem
    def initialize(params)
      @product_id = params.fetch("product_id").to_i
      @quantity = params.fetch("quantity").to_i

      @product = FetchProduct.new.call(@product_id)
    end

    def call
      BASKET.update(@product, @quantity)
    end
  end
end
