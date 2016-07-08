require_relative "../../lib/product_not_found"
require_relative "../../lib/basket"
require_relative "../../lib/warehouse"
require_relative "../../lib/product"

RSpec.describe "Basket" do
  let(:product) { Product.new(name: "Ball", price: 10) }

  it "has 1 arg" do
    expect {
      Basket.new(Warehouse.new)
    }.not_to raise_error
  end

  describe "#add" do
    context "product in stock" do
      before do
        @warehouse = Warehouse.new
        @basket = Basket.new(@warehouse)

        @warehouse.add_product(product: product, quantity: 10)
      end

      it "adds new product to basket's items" do
        expect {
          @basket.add(product)
        }.to change { @basket.items.size }.by(1)
      end

      it "doesn't add existing basket's product to basket's items" do
        @basket.add(product)

        expect {
          @basket.add(product)
        }.not_to change { @basket.items.size }
      end

      it "increases product quantity in basket for existing basket's product" do
        @basket.add(product)

        expect {
          @basket.add(product)
        }.to change { @basket.items.first.quantity }.by(1)
      end

      it "decreases product status' quantity" do
        expect {
          @basket.add(product)
        }.to change { @warehouse.statuses.first.quantity }.by(-1)
      end
    end

    context "product out of stock" do
      before do
        @warehouse = Warehouse.new
        @basket = Basket.new(@warehouse)

        @warehouse.add_product(product: product, quantity: 0)
      end

      it "raises error" do
        expect {
          @basket.add(product)
        }.to raise_error ProductNotFound
      end

      it "doesn't add new product to basket's items" do
        expect {
          @basket.add(product) rescue nil
        }.not_to change { @basket.items.size }
      end
    end

    context "nil product" do
      before do
        @warehouse = Warehouse.new
        @basket = Basket.new(@warehouse)

        @warehouse.add_product(product: product, quantity: 1)
      end

      it "raises error" do
        expect {
          @basket.add(nil)
        }.to raise_error ArgumentError
      end
    end
  end

  describe "#remove" do
    context "product in basket" do
      before do
        @warehouse = Warehouse.new
        @basket = Basket.new(@warehouse)

        @warehouse.add_product(product: product, quantity: 10)
      end

      it "removes item from basket" do
        @basket.add(product)

        expect {
          @basket.remove(product)
        }.to change { @basket.items.size }.by(-1)
      end

      it "decreases item quantity in basket for quantity > 1" do
        10.times { @basket.add(product) }

        expect {
          @basket.remove(product)
        }.to change { @basket.items.first.quantity }.by(-1)
      end

      it "doesn't remove item from basket for quantity > 1" do
        10.times { @basket.add(product) }

        expect {
          @basket.remove(product)
        }.not_to change { @basket.items.size }
      end

      it "increases product status' quantity" do
        10.times { @basket.add(product) }

        expect {
          @basket.remove(product)
        }.to change { @warehouse.statuses.first.quantity }.by(1)
      end
    end

    context "product not in basket" do
      before do
        @warehouse = Warehouse.new
        @basket = Basket.new(@warehouse)

        @warehouse.add_product(product: product, quantity: 10)
      end

      it "raises error" do
        expect {
          @basket.remove(Product.new(name: "foo", price: 1000))
        }.to raise_error ProductNotFound
      end
    end

    context "product nil" do
      before do
        @warehouse = Warehouse.new
        @basket = Basket.new(@warehouse)

        @warehouse.add_product(product: product, quantity: 10)
      end

      it "raises error" do
        expect {
          @basket.remove(nil)
        }.to raise_error ArgumentError
      end
    end
  end

  describe "#sum" do
    before do
      @warehouse = Warehouse.new
      @basket = Basket.new(@warehouse)

      @warehouse.add_product(product: product, quantity: 10)

      10.times { @basket.add(product) }
    end

    it "returns proper price" do
      expect(@basket.sum.to_f).to eql(100.0)
    end
  end

  describe "#sum_with_vat" do
    before do
      @warehouse = Warehouse.new
      @basket = Basket.new(@warehouse)

      @warehouse.add_product(product: product, quantity: 10)

      10.times { @basket.add(product) }
    end

    it "returns proper price" do
      expect(@basket.sum_with_vat.to_f).to eql(123.0)
    end
  end
end
