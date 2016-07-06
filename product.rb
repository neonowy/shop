class Product
  attr_reader :id, :name

  @@id = 0

  def initialize(name:, price:, discount: 0, vat: 0.23)
    @id = next_id
    @name = name
    @price = price

    @vat = vat

    unless discount == 0
      @discount = discount
    end
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
end
