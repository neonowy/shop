require_relative "../../lib/model/basket_item"
require_relative "../../lib/model/product"

module Shop
  RSpec.describe Shop::BasketItem do
    subject(:basket_item) { BasketItem.new(product) }

    let(:price) { 10 }
    let(:product) { Product.new(name: "Ball", price: price) }

    describe "#quantity" do
      it "is 0 after creation" do
        expect(basket_item.quantity).to eq(0)
      end
    end

    describe "#price" do
      before do
        basket_item.quantity = 6
      end

      it "returns proper price" do
        expect(basket_item.price).to eq(6 * price)
      end
    end

    describe "#price_with_vat" do
      before do
        basket_item.quantity = 6
      end

      it "returns proper price + VAT" do
        expect(basket_item.price_with_vat).to be_within(0.0001).of(6 * price * 1.23)
      end
    end
  end
end
