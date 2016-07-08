require_relative "../../lib/warehouse"
require_relative "../../lib/product"
require_relative "../../lib/product_not_found"

RSpec.describe Warehouse do
  subject(:warehouse) { Warehouse.new }
  let(:product) { Product.new(name: "Ball", price: 10) }

  it "has no args" do
    expect {
      Warehouse.new
    }.to_not raise_error
  end

  describe "#add_product" do
    it "adds status to statuses list" do
      expect {
        warehouse.add_product(product: product, quantity: 10)
      }.to change { warehouse.statuses.size }.by(1)
    end
  end

  describe "#increase_product_status" do
    context "with product" do
      before { warehouse.add_product(product: product, quantity: 1) }

      it "increase product status' quantity by one" do
        expect {
          warehouse.increase_product_status(product)
        }.to change { warehouse.statuses.first.quantity }.from(1).to(2)
      end
    end

    context "when product is not in warehouse" do
      it "raises error" do
        expect {
          warehouse.increase_product_status(product)
        }.to raise_error ProductNotFound
      end
    end

    context "when product is nil" do
      before { warehouse.add_product(product: product, quantity: 1) }

      it "raises error" do
        expect {
          warehouse.increase_product_status(nil)
        }.to raise_error ArgumentError
      end
    end
  end

  describe "#decrease_product_status" do
    context "when quantity is two" do
      before { warehouse.add_product(product: product, quantity: 2) }

      it "decrease product status' quantity by one" do
        expect {
          warehouse.decrease_product_status(product)
        }.to change { warehouse.statuses.first.quantity }.from(2).to(1)
      end
    end

    context "when quantity is already zero" do
      before { warehouse.add_product(product: product, quantity: 0) }

      it "raises error" do
        expect {
          warehouse.decrease_product_status(product)
        }.to raise_error(StandardError)
      end
    end

    context "when product is not in warehouse" do
      it "raises error" do
        expect {
          warehouse.decrease_product_status(product)
        }.to raise_error ProductNotFound
      end
    end

    context "when product is nil" do
      before { warehouse.add_product(product: product, quantity: 1) }

      it "raises error" do
        expect {
          warehouse.decrease_product_status(nil)
        }.to raise_error ArgumentError
      end
    end
  end

  describe "#in_stock?" do
    context "when product in stock" do
      before { warehouse.add_product(product: product, quantity: 10) }

      it "returns true" do
        expect(warehouse.in_stock?(product)).to be(true)
      end
    end

    context "when product is out of stock" do
      before { warehouse.add_product(product: product, quantity: 0) }

      it "returns false" do
        expect(warehouse.in_stock?(product)).to be(false)
      end
    end

    context "when product is not in warehouse" do
      it "raises error" do
        expect {
          warehouse.in_stock?(product)
        }.to raise_error ProductNotFound
      end
    end

    context "when product is nil" do
      it "raises error" do
        expect {
          warehouse.in_stock?(nil)
        }.to raise_error ArgumentError
      end
    end
  end
end
