require_relative "./shop"

class Main
  def self.run
    shop = Shop.new
    first_user = shop.add_user("Jan Kowalski")
    second_user = shop.add_user("John Doe")

    shop.generate_sample_data

    10.times do
      first_user.add_to_basket(shop.products[0])
    end

    first_user.remove_from_basket(shop.products[0])

    first_user.add_to_basket(shop.products[1])
    first_user.add_to_basket(shop.products[2])

    4.times do
      second_user.add_to_basket(shop.products[1])
    end

    first_user.print_invoice
    puts ""
    second_user.print_invoice
  end
end

Main.run
