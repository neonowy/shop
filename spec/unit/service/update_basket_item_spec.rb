require "./lib/service/update_basket_item"
require "./lib/model/basket_item"

module Shop
  RSpec.describe Shop::UpdateBasketItem do
    let(:product) { Product.new(name: "Doge", price: 1000, discount: 0.2) }
    let(:quantity) { 10 }

    before do
      clear_data

      PRODUCTS << product
    end

    describe "#call" do
      context "with valid params" do
        let(:params) { { "product_id" => product.id.to_s, "quantity" => quantity.to_s } }
        let!(:BASKET) { double("Shop::BASKET") }

        before do
          expect(BASKET).to receive(:update).with(product, quantity)
        end

        it "calls BASKET.update with proper params" do
          UpdateBasketItem.new(params).call
        end
      end

      context "with nil product_id" do
        let(:params) { { "product_id" => nil, "quantity" => quantity.to_s } }

        it "raises error" do
          expect {
            UpdateBasketItem.new(params).call
          }.to raise_error(ProductNotFound)
        end
      end

      context "with invalid params" do
        let(:params) { { "foo" => "bar", "fooo" => 10 } }

        it "raises error" do
          expect {
            UpdateBasketItem.new(params).call
          }.to raise_error(KeyError)
        end
      end
    end
  end
end
