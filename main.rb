require_relative "./shop"

class Main
  def self.run
    shop = Shop.new

    shop.generate_sample_data

    10.times do
      shop.add_to_basket(shop.products[0])
    end

    shop.remove_from_basket(shop.products[0])

    shop.add_to_basket(shop.products[1])
    shop.add_to_basket(shop.products[2])

    shop.print_invoice
  end
end

Main.run
