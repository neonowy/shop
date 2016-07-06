class Invoice
  def initialize(basket)
    @basket = basket
  end

  def print
    @basket.items.each_with_index do |item, index|
      print_basket_item(item, index)
    end

    print_summary
  end

  private

  def print_basket_item(item, index)
    product = item.product
    quantity = item.quantity

    item_no = index + 1

    product_price = '%.2f' % product.price
    item_price = '%.2f' % item.price

    if quantity > 1
      puts "#{item_no}. #{product.name} #{quantity}szt. x #{product_price} PLN = #{item_price} PLN"
    else
      puts "#{item_no}. #{product.name} = #{item_price} PLN"
    end
  end

  def print_summary
    sum = '%.2f' % @basket.sum
    sum_with_vat = '%.2f' % @basket.sum_with_vat

    puts "------------------"
    puts "    Suma: #{sum} PLN"
    puts "   z VAT: #{sum_with_vat} PLN"
  end
end