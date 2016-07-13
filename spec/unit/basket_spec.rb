require_relative "../../lib/model/basket"
require_relative "../../lib/model/warehouse"
require_relative "../../lib/model/product"

module Shop
  WAREHOUSE = Warehouse.new

  RSpec.describe Shop::Basket do
    let(:product) { Product.new(name: "Ball", price: 10) }

    it "takes no args" do
      expect {
        Basket.new
      }.not_to raise_error
    end

    describe "#add" do
      context "product in stock" do
        before do
          @basket = Basket.new

          WAREHOUSE.statuses.clear
          WAREHOUSE.add_product(product: product, quantity: 10)
        end

        it "adds new product to basket's items" do
          expect {
            @basket.add(product, 5)
          }.to change { @basket.items.size }.by(1)
        end

        it "doesn't add existing basket's product to basket's items" do
          @basket.add(product, 1)

          expect {
            @basket.add(product, 5)
          }.not_to change { @basket.items.size }
        end

        it "increases product quantity in basket for existing basket's product" do
          @basket.add(product, 1)

          expect {
            @basket.add(product, 5)
          }.to change { @basket.items.first.quantity }.by(5)
        end

        it "decreases product status' quantity" do
          expect {
            @basket.add(product, 5)
          }.to change { WAREHOUSE.statuses.last.quantity }.by(-5)
        end
      end

      context "product out of stock" do
        before do
          @basket = Basket.new

          WAREHOUSE.statuses.clear
          WAREHOUSE.add_product(product: product, quantity: 0)
        end

        it "raises error" do
          expect {
            @basket.add(product, 5)
          }.to raise_error(QuantityLevelError)
        end

        it "doesn't add new product to basket's items" do
          expect {
            @basket.add(product, 5) rescue nil
          }.not_to change { @basket.items.size }
        end
      end

      context "nil product" do
        before do
          @basket = Basket.new

          WAREHOUSE.statuses.clear
          WAREHOUSE.add_product(product: product, quantity: 1)
        end

        it "raises error" do
          expect {
            @basket.add(nil, 5)
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#remove" do
      context "product in basket" do
        before do
          @basket = Basket.new

          WAREHOUSE.statuses.clear
          WAREHOUSE.add_product(product: product, quantity: 10)
        end

        it "removes item from basket" do
          @basket.add(product, 1)

          expect {
            @basket.remove(product)
          }.to change { @basket.items.size }.by(-1)
        end

        it "decreases item quantity in basket for quantity > 1" do
          @basket.add(product, 10)

          expect {
            @basket.remove(product)
          }.to change { @basket.items.first.quantity }.by(-1)
        end

        it "doesn't remove item from basket for quantity > 1" do
          @basket.add(product, 10)

          expect {
            @basket.remove(product)
          }.not_to change { @basket.items.size }
        end

        it "increases product status' quantity" do
          @basket.add(product, 10)

          expect {
            @basket.remove(product)
          }.to change { WAREHOUSE.statuses.last.quantity }.by(1)
        end
      end

      context "product not in basket" do
        before do
          @basket = Basket.new

          WAREHOUSE.statuses.clear
          WAREHOUSE.add_product(product: product, quantity: 10)
        end

        it "raises error" do
          expect {
            @basket.remove(Product.new(name: "foo", price: 1000))
          }.to raise_error(NotInBasket)
        end
      end

      context "product nil" do
        before do
          @basket = Basket.new

          WAREHOUSE.statuses.clear
          WAREHOUSE.add_product(product: product, quantity: 10)
        end

        it "raises error" do
          expect {
            @basket.remove(nil)
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#sum" do
      before do
        @basket = Basket.new

        WAREHOUSE.statuses.clear
        WAREHOUSE.add_product(product: product, quantity: 10)

        @basket.add(product, 10)
      end

      it "returns proper price" do
        expect(@basket.sum.to_f).to eql(100.0)
      end
    end

    describe "#sum_with_vat" do
      before do
        @basket = Basket.new

        WAREHOUSE.statuses.clear
        WAREHOUSE.add_product(product: product, quantity: 10)

        @basket.add(product, 10)
      end

      it "returns proper price" do
        expect(@basket.sum_with_vat.to_f).to eql(123.0)
      end
    end
  end
end
