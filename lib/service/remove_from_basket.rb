module Shop
  class RemoveFromBasket
    def initialize(params)
      @product_id = params[:id].to_i
      @product = FetchProduct.new.call(@product_id)
    end

    def call
      BASKET.remove(@product)
    end
  end
end
