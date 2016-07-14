require "./lib/service/fetch_warehouse"
require "./lib/model/warehouse"

module Shop
  WAREHOUSE = Warehouse.new

  RSpec.describe Shop::FetchWarehouse do
    subject(:fetch_warehouse) { Shop::FetchWarehouse.new }
    let(:product) { Product.new(name: "Doge", price: 1000, discount: 0.2) }

    before do
      Shop::WAREHOUSE.add_product(product: product, quantity: 10)
    end

    describe "#call" do
      it "returns Shop::WAREHOUSE" do
        expect(fetch_warehouse.call).to eql(Shop::WAREHOUSE)
      end
    end
  end
end
