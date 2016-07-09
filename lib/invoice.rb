class Invoice
  def initialize(buyer:, basket:)
    @buyer = buyer
    @basket = basket
  end

  def generate_invoice
    "".tap do |invoice|
      invoice << generate_header

      @basket.items.each_with_index do |basket_item, index|
        invoice << generate_invoice_item(basket_item, index)
      end

      invoice << generate_summary
    end
  end

  private

  def generate_invoice_item(basket_item, index)
    product = basket_item.product
    quantity = basket_item.quantity

    item_no = index + 1

    item_price = '%.2f' % basket_item.price
    product_price = '%.2f' % product.price

    if quantity > 1
      "#{item_no}. #{product.name} #{quantity}szt. x #{product_price} PLN = #{item_price} PLN\n"
    else
      "#{item_no}. #{product.name} = #{item_price} PLN\n"
    end
  end

  def generate_header
    header = ""

    header += "Rachunek dla:\n"
    header += "#{@buyer}\n"
    header += "------------------\n\n"

    header
  end

  def generate_summary
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
