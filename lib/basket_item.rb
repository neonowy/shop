require_relative "./exceptions"

class BasketItem
  attr_reader :product, :quantity

  def initialize(product)
    @product = product
    @quantity = 0
  end

  def increase_quantity
    @quantity += 1
  end

  def decrease_quantity
    raise QuantityLevelError unless @quantity > 0

    @quantity -= 1
  end

  def price_with_vat
    @quantity * @product.price_with_vat
  end

  def price
    @quantity * @product.price
  end
end
