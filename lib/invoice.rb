class Invoice
  def initialize(buyer:, basket:)
    @buyer = buyer
    @basket = basket
  end

  def get_invoice
    invoice = ""

    invoice += get_header

    @basket.items.each_with_index do |item, index|
      invoice += get_basket_item(item, index)
    end

    invoice += get_summary

    invoice
  end

  private

  def get_basket_item(item, index)
    product = item.product
    quantity = item.quantity

    item_no = index + 1

    product_price = '%.2f' % product.price
    item_price = '%.2f' % item.price

    if quantity > 1
      "#{item_no}. #{product.name} #{quantity}szt. x #{product_price} PLN = #{item_price} PLN\n"
    else
      "#{item_no}. #{product.name} = #{item_price} PLN\n"
    end
  end

  def get_header
    header = ""

    header += "Rachunek dla:\n"
    header += "#{@buyer}\n"
    header += "------------------\n\n"

    header
  end

  def get_summary
    summary = ""

    sum = '%.2f' % @basket.sum
    sum_with_vat = '%.2f' % @basket.sum_with_vat

    summary += "\n"
    summary += "------------------\n"
    summary += "  Suma: #{sum} PLN\n"
    summary += " z VAT: #{sum_with_vat} PLN\n"

    summary
  end
end
