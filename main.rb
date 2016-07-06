require_relative "./product"
require_relative "./basket"
require_relative "./warehouse"
require_relative "./invoice"

@products = []

@warehouse = Warehouse.new
@basket = Basket.new(@warehouse)
@invoice = Invoice.new(@basket)

@products << Product.new(name: "Ball", price: 30, discount: 0.5)
@products << Product.new(name: "Coca-Cola 2l", price: 5.50)
@products << Product.new(name: "Book", price: 12, vat: 0.08)

@products.each do |p|
  @warehouse.add_product(product: p, quantity: 10)
end

10.times do
  @basket.add(@products[0])
end

@basket.remove(@products[0])

@basket.add(@products[1])
@basket.add(@products[2])

@invoice.print
