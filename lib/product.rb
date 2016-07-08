class Product
  attr_reader :id, :name

  @@id = 0

  def initialize(name:, price:, discount: nil, vat: 0.23)
    @id = next_id

    @name = set_name(name)
    @price = set_price(price)
    @vat = set_vat(vat)
    @discount = set_discount(discount)
  end

  def price_with_vat
    price + (price * @vat)
  end

  def price
    if @discount
      @price - (@price * @discount)
    else
      @price
    end
  end

  private

  def next_id
    @@id += 1
  end

  def set_name(name)
    raise ArgumentError unless name.is_a?(String)
    raise ArgumentError unless name.length > 1

    name
  end

  def set_price(price)
    raise ArgumentError unless price.is_a?(Numeric)
    raise ArgumentError unless price > 0

    price
  end

  def set_vat(vat)
    raise ArgumentError unless vat.is_a?(Float)
    raise ArgumentError unless vat >= 0 && vat < 1

    vat
  end

  def set_discount(discount)
    if discount
      raise ArgumentError unless discount.is_a?(Float)
      raise ArgumentError unless discount > 0 && discount < 1
    end

    discount
  end
end
