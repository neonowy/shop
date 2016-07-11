require_relative './basket'

class User
  attr_reader :name, :warehouse, :basket

  def initialize(name:, shop:)
    @name = name
    @warehouse = shop.warehouse
    @basket = Basket.new(warehouse)
  end

  def add_to_basket(product)
    basket.add(product)
  end

  def remove_from_basket(product)
    basket.remove(product)
  end

  def generate_invoice
    Invoice.new(buyer: name, basket: basket).generate_invoice
  end
end
