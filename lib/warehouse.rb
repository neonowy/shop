require_relative './product_status'
require_relative './product_not_found'

class Warehouse
  attr_reader :statuses

  def initialize
    @statuses = []
  end

  def add_product(product:, quantity:)
    status = ProductStatus.new(product: product, quantity: quantity)

    @statuses << status
  end

  def increase_product_status(product)
    status = find_product_status(product)

    raise ArgumentError unless product
    raise ProductNotFound unless status

    status.quantity += 1
  end

  def decrease_product_status(product)
    status = find_product_status(product)

    raise ArgumentError unless product
    raise ProductNotFound unless status
    raise StandardError unless status.quantity > 0

    status.quantity -= 1
  end

  def in_stock?(product)
    status = find_product_status(product)

    raise ArgumentError unless product
    raise ProductNotFound unless status

    status.quantity > 0
  end

  private

  def find_product_status(product)
    @statuses.find { |s| s.product == product }
  end
end
