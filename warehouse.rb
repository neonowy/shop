require_relative './product_status'

class Warehouse
  def initialize
    @statuses = []
  end

  def add_product(product:, quantity:)
    status = ProductStatus.new(product: product, quantity: quantity)

    @statuses << status
  end

  def increase_product_status(product)
    status = find_product_status(product)

    status.quantity += 1
  end

  def decrease_product_status(product)
    status = find_product_status(product)

    status.quantity -= 1
  end

  def in_stock?(product)
    status = find_product_status(product)

    status.quantity > 0
  end

  private

  def find_product_status(product)
    @statuses.find { |s| s.product == product }
  end
end