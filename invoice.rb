class Invoice
  def initialize(buyer:, basket:)
    @buyer = buyer
    @basket = basket
  end

  def print
    print_header

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

  def print_header
    puts "Rachunek dla:"
    puts @buyer
    puts "------------------"
    puts ""
  end

  def print_summary
    sum = '%.2f' % @basket.sum
    sum_with_vat = '%.2f' % @basket.sum_with_vat

    puts ""
    puts "------------------"
    puts "  Suma: #{sum} PLN"
    puts " z VAT: #{sum_with_vat} PLN"
  end
end