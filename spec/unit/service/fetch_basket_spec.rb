require "./lib/service/fetch_basket"
require "./lib/model/basket"

module Shop
  WAREHOUSE = Warehouse.new
  BASKET = Basket.new

  RSpec.describe Shop::FetchBasket do
    subject(:fetch_basket) { Shop::FetchBasket.new }
    let(:product) { Product.new(name: "Doge", price: 1000, discount: 0.2) }

    describe "#call" do
      it "returns Shop::WAREHOUSE" do
        expect(fetch_basket.call).to eql(Shop::BASKET)
      end
    end
  end
end
