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

    def update(product, quantity)
      warehouse = FetchWarehouse.new.call
      item = find_item(product)

      warehouse_quantity = warehouse.status_for(product).quantity
      current_quantity = item.quantity

      raise ArgumentError unless product.is_a?(Product)
      raise NegativeQuantityError unless quantity >= 0
      raise NotInBasket unless item
      raise QuantityLevelError unless warehouse_quantity + current_quantity >= quantity

      if quantity == 0
        remove(product)
      else
        add(product, quantity - current_quantity)
      end
    end

    def add(product, quantity)
      warehouse = FetchWarehouse.new.call
      product_status = warehouse.status_for(product)

      raise ArgumentError unless product.is_a?(Product)
      raise QuantityLevelError unless product_status.quantity - quantity >= 0

      item = find_or_create_item(product)

      item.quantity += quantity
      product_status.quantity -= quantity
    end

    def remove(product)
      warehouse = FetchWarehouse.new.call
      product_status = warehouse.status_for(product)

      item = find_item(product)
      item_index = find_item_index(item)

      raise ArgumentError if product.nil?
      raise NotInBasket unless item

      product_status.quantity += item.quantity

      @items.delete_at(item_index)
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

    def find_item_index(item)
      @items.find_index { |i| i == item }
    end
  end
end
