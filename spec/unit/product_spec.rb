require_relative "../../lib/model/product"

module Shop
  RSpec.describe Shop::Product do
    let(:name) { "Ball" }
    let(:price) { 10 }

    subject(:product) { Product.new(name: name, price: price) }
    subject(:discount_product) { Product.new(name: name, price: price, discount: 0.5) }

    it "has at least 2 args" do
      expect {
        Product.new(name: name, price: price)
      }.to_not raise_error
    end

    describe "#name" do
      it "returns proper name" do
        expect(product.name).to eql(name)
      end

      it "raises error for invalid name" do
        expect {
          Product.new(name: 1, price: price)
        }.to raise_error(ArgumentError)
      end

      it "must have at least 2 chars" do
        expect {
          Product.new(name: "a", price: price)
        }.to raise_error(ArgumentError)
      end
    end

    describe "#price" do
      it "returns proper price" do
        expect(product.price).to eql(price)
      end

      it "raises error for invalid price" do
        expect {
          Product.new(name: name, price: nil)
        }.to raise_error(ArgumentError)
      end

      it "must be > 0" do
        expect {
          Product.new(name: name, price: -10)
        }.to raise_error(ArgumentError)
      end

      context "when discounted" do
        it "returns discounted price" do
          expect(discount_product.price).to eql(5.0)
        end
      end
    end

    describe "#price_with_vat" do
      it "returns proper price + VAT" do
        expect(product.price_with_vat).to eql(12.3)
      end

      context "when custom rate" do
        it "returns proper price + custom VAT" do
          product = Product.new(name: name, price: price, vat: 0.08)

          expect(product.price_with_vat).to eql(10.8)
        end
      end

      context "when discounted" do
        it "returns discounted price + VAT" do
          expect(discount_product.price_with_vat).to eql(6.15)
        end
      end
    end

    describe "#vat" do
      it "raises error for invalid VAT" do
        expect {
          Product.new(name: name, price: price, vat: "foo")
        }.to raise_error(ArgumentError)
      end

      it "must be >= 0" do
        expect {
          Product.new(name: name, price: price, vat: -0.23)
        }.to raise_error(ArgumentError)
      end

      it "must be < 1" do
        expect {
          Product.new(name: name, price: price, vat: 23.0)
        }.to raise_error(ArgumentError)
      end
    end

    describe "#discount" do
      it "raises error for invalid discount" do
        expect {
          Product.new(name: name, price: price, discount: "foo")
        }.to raise_error(ArgumentError)
      end

      it "must be > 0" do
        expect {
          Product.new(name: name, price: price, discount: -0.5)
        }.to raise_error(ArgumentError)
      end

      it "must be < 1" do
        expect {
          Product.new(name: name, price: price, discount: 50)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
