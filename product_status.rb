class ProductStatus
  attr_accessor :quantity
  attr_reader :product

  def initialize(product:, quantity:)
    @product = product
    @quantity = quantity
  end
end