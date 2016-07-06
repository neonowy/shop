require_relative "./product"
require_relative "./basket"
require_relative "./warehouse"
require_relative "./invoice"

class Shop
  attr_reader :products, :warehouse, :basket

  def initialize
    @products = []
    @warehouse = Warehouse.new
    @basket = Basket.new(warehouse)
  end

  def add_to_basket(product)
    basket.add(product)
  end

  def remove_from_basket(product)
    basket.remove(product)
  end

  def print_invoice
    invoice = Invoice.new(basket)

    invoice.print
  end

  def generate_sample_data
    products << Product.new(name: "Ball", price: 30, discount: 0.5)
    products << Product.new(name: "Coca-Cola 2l", price: 5.50)
    products << Product.new(name: "Book", price: 12, vat: 0.08)

    products.each do |p|
      warehouse.add_product(product: p, quantity: 10)
    end
  end
end
