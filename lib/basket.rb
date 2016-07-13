require_relative './exceptions'
require_relative './basket_item'
require_relative './warehouse'
require_relative './product'

class Basket
  attr_reader :items, :warehouse

  def initialize(warehouse)
    @warehouse = warehouse
    @items = []
  end

  def add(product)
    raise ArgumentError unless product.is_a?(Product)

    if warehouse.in_stock?(product)
      item = find_or_create_item(product)

      item.increase_quantity

      warehouse.decrease_product_status(product)
    else
      raise ProductNotFound
    end
  end

  def remove(product)
    item = find_item(product)
    item_index = find_item_index(product)

    raise ArgumentError if product.nil?
    raise ProductNotFound unless item

    warehouse.increase_product_status(product)

    if item.quantity == 1
      @items.delete_at(item_index)
    else
      item.decrease_quantity
    end
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
