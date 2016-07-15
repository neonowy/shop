require_relative "../../lib/model/basket"
require_relative "../../lib/model/warehouse"
require_relative "../../lib/model/product"

module Shop
  RSpec.describe Shop::Basket do
    subject(:basket) { Basket.new }
    let(:product) { Product.new(name: "Ball", price: 10) }

    before do
      clear_data

      basket.items.clear
    end

    it "takes no args" do
      expect {
        Basket.new
      }.to_not raise_error
    end

    describe "#add" do
      context "product in stock" do
        before do
          WAREHOUSE.add_product(product: product, quantity: 10)
        end

        it "adds new product to basket's items" do
          expect {
            basket.add(product, 5)
          }.to change { basket.items.size }.by(1)
        end

        it "doesn't add existing basket's product to basket's items" do
          basket.add(product, 1)

          expect {
            basket.add(product, 5)
          }.to_not change { basket.items.size }
        end

        it "increases product quantity in basket for existing basket's product" do
          basket.add(product, 1)

          expect {
            basket.add(product, 5)
          }.to change { basket.items.first.quantity }.by(5)
        end

        it "decreases product status' quantity" do
          expect {
            basket.add(product, 5)
          }.to change { WAREHOUSE.statuses.last.quantity }.by(-5)
        end
      end

      context "product out of stock" do
        before do
          WAREHOUSE.statuses.clear
          WAREHOUSE.add_product(product: product, quantity: 0)
        end

        it "raises error" do
          expect {
            basket.add(product, 5)
          }.to raise_error(QuantityLevelError)
        end

        it "doesn't add new product to basket's items" do
          expect {
            basket.add(product, 5) rescue nil
          }.to_not change { basket.items }
        end
      end

      context "nil product" do
        before do
          WAREHOUSE.add_product(product: product, quantity: 1)
        end

        it "raises error" do
          expect {
            basket.add(nil, 5)
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#update" do
      before do
        WAREHOUSE.add_product(product: product, quantity: 10)

        basket.add(product, 5)
      end

      context "when enough quantity in stock" do
        it "updates basket item" do
          expect {
            basket.update(product, 2)
          }.to change { basket.items.last.quantity }.from(5).to(2)
        end

        it "updates warehouse status" do
          expect {
            basket.update(product, 2)
          }.to change { WAREHOUSE.statuses.last.quantity }.from(5).to(8)
        end
      end

      context "when not enough quantity in stock" do
        it "raises error" do
          expect {
            basket.update(product, 15)
          }.to raise_error(QuantityLevelError)
        end

        it "doesn't update basket item" do
          expect {
            basket.update(product, 15) rescue nil
          }.to_not change { basket }
        end

        it "doesn't update warehouse status" do
          expect {
            basket.update(product, 15) rescue nil
          }.to_not change { WAREHOUSE }
        end
      end

      context "with zero quantity" do
        it "remove item from basket" do
          expect {
            basket.update(product, 0)
          }.to change { basket.items.size }.by(-1)
        end

        it "increases warehouse status' quantity" do
          expect {
            basket.update(product, 0)
          }.to change { WAREHOUSE.statuses.last.quantity }.by(5)
        end
      end

      context "with negative quantity" do
        it "raises error" do
          expect {
            basket.update(product, -5)
          }
        end
      end

      context "with nil product" do
        it "raises error" do
          expect {
            basket.update(nil, 5)
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#remove" do
      before do
        WAREHOUSE.add_product(product: product, quantity: 10)
      end

      context "with product in basket" do
        it "removes item from basket" do
          basket.add(product, 1)

          expect {
            basket.remove(product)
          }.to change { basket.items.size }.by(-1)
        end

        it "increases product status' quantity" do
          basket.add(product, 10)

          expect {
            basket.remove(product)
          }.to change { WAREHOUSE.statuses.last.quantity }.by(10)
        end
      end

      context "with product not in basket" do
        let(:second_product) { Product.new(name: "foo", price: 1000) }

        before do
          WAREHOUSE.add_product(product: second_product, quantity: 10)
        end

        it "raises error" do
          expect {
            basket.remove(second_product)
          }.to raise_error(NotInBasket)
        end
      end

      context "with nil product" do
        it "raises error" do
          expect {
            basket.remove(nil)
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#sum" do
      before do
        WAREHOUSE.add_product(product: product, quantity: 10)

        basket.add(product, 10)
      end

      it "returns proper price" do
        expect(basket.sum.to_f).to eql(100.0)
      end
    end

    describe "#sum_with_vat" do
      before do
        WAREHOUSE.add_product(product: product, quantity: 10)

        basket.add(product, 10)
      end

      it "returns proper price" do
        expect(basket.sum_with_vat.to_f).to eql(123.0)
      end
    end
  end
end
