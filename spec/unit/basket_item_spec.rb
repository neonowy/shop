require_relative "../../lib/basket_item.rb"

RSpec.describe BasketItem do
  subject(:basket_item) { BasketItem.new(product) }
  let(:product) { Product.new(name: "Ball", price: 10) }

  describe "#quantity" do
    it "is 0 after creation" do
      expect(basket_item.quantity).to eq(0)
    end
  end

  describe "#increase_quantity" do
    it "increases quantity by one" do
      expect {
        basket_item.increase_quantity
      }.to change { basket_item.quantity }.from(0).to(1)
    end
  end

  describe "#decrease_quantity" do
    context "when quantity is two" do
      before { 2.times { basket_item.increase_quantity } }

      it "decreases quantity by one" do
        expect {
          basket_item.decrease_quantity
        }.to change { basket_item.quantity }.from(2).to(1)
      end
    end

    context "when quantity is already zero" do
      it "raises error" do
        expect {
          basket_item.decrease_quantity
        }.to raise_error StandardError
      end
    end
  end

  describe "#price" do
    before { 6.times { basket_item.increase_quantity } }

    it "returns proper price" do
      expect(basket_item.price).to eq(60)
    end
  end

  describe "#price_with_vat" do
    before { 6.times { basket_item.increase_quantity } }

    it "returns proper price + VAT" do
      expect(basket_item.price_with_vat).to eq(6 * 12.3)
    end
  end
end
