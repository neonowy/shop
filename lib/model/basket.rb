require_relative "../exceptions"
require_relative "../helper/format_helper"

require_relative "../service/fetch_warehouse"

require_relative "./basket_item"
require_relative "./warehouse"
require_relative "./product"

module Shop
  class Basket
    include FormatHelper

    attr_reader :items

    def initialize
      @items = []
    end

    def add(product, quantity)
      warehouse = FetchWarehouse.new.call

      raise ArgumentError unless product.is_a?(Product)

      if warehouse.status_for(product).quantity - quantity >= 0
        item = find_or_create_item(product)

        quantity.times do
          item.increase_quantity
          warehouse.decrease_product_status(product)
        end
      else
        raise QuantityLevelError
      end
    end

    def remove(product)
      warehouse = FetchWarehouse.new.call

      item = find_item(product)
      item_index = find_item_index(product)

      raise ArgumentError if product.nil?
      raise NotInBasket unless item

      warehouse.increase_product_status(product)

      if item.quantity == 1
        @items.delete_at(item_index)
      else
        item.decrease_quantity
      end
    end

    def formatted_sum_with_vat
      format_money(sum_with_vat)
    end

    def formatted_sum
      format_money(sum)
    end

    def sum_with_vat
      @items.map(&:price_with_vat).reduce(0, :+)
    end

    def sum
      @items.map(&:price).reduce(0, :+)
    end

    private

    def find_or_create_item(product)
      item = find_item(product)

      unless item
        item = BasketItem.new(product)

        @items << item
      end

      item
    end

    def find_item(product)
      @items.find { |i| i.product == product }
    end

    def find_item_index(product)
      @items.index { |i| i.product == product }
    end
  end
end
