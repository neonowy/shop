require_relative "./lib/shop"

class Main
  def self.run
    shop = Shop.new
    first_user = shop.add_user("Jan Kowalski")
    second_user = shop.add_user("John Doe")

    shop.generate_sample_data

    10.times do
      begin
        first_user.add_to_basket(shop.products[0])
      rescue ProductNotFound
        puts "Sorry, product is not available at the moment :("
      end
    end

    first_user.remove_from_basket(shop.products[0])

    first_user.add_to_basket(shop.products[1])
    first_user.add_to_basket(shop.products[2])

    4.times do
      second_user.add_to_basket(shop.products[1])
    end

    puts first_user.generate_invoice
    puts ""
    puts second_user.generate_invoice
  end
end

Main.run
