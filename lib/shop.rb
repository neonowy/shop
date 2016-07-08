require_relative "./product"
require_relative "./basket"
require_relative "./warehouse"
require_relative "./invoice"
require_relative "./user"

class Shop
  attr_reader :products, :users, :warehouse, :basket

  def initialize
    @products = []
    @users = []
    @warehouse = Warehouse.new
  end

  def add_user(name)
    user = User.new(name: name, shop: self)
    users << user

    user
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
