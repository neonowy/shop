require_relative "../exceptions"
require_relative "../helper/format_helper"

module Shop
  class BasketItem
    include FormatHelper

    attr_reader :product, :quantity

    def initialize(product)
      @product = product
      @quantity = 0
    end

    def increase_quantity
      @quantity += 1
    end

    def decrease_quantity
      raise QuantityLevelError unless @quantity > 0

      @quantity -= 1
    end

    def formatted_price
      format_money(price)
    end

    def price_with_vat
      @quantity * @product.price_with_vat
    end

    def price
      @quantity * @product.price
    end
  end
end
