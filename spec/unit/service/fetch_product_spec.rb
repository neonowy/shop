require "./lib/exceptions"

require_relative "../../../lib/service/fetch_product"
require_relative "../../../lib/model/product"

module Shop
  PRODUCTS = []

  RSpec.describe Shop::FetchProduct do
    subject(:fetch_product) { Shop::FetchProduct.new }

    let(:first_product) { Product.new(name: "Doge", price: 1000, discount: 0.2) }
    let(:second_product) { Product.new(name: "Doge Sticker", price: 2) }

    before do
      Shop::PRODUCTS << first_product
      Shop::PRODUCTS << second_product
    end

    describe "#call" do
      context "with an existing product" do
        before do
          @first_id = first_product.id
          @second_id = second_product.id
        end

        it "returns proper product" do
          expect(fetch_product.call(@first_id)).to eql(first_product)
          expect(fetch_product.call(@second_id)).to eql(second_product)
        end
      end

      context "with not existing id" do
        it "raises error" do
          expect {
            fetch_product.call(-1)
          }.to raise_error ProductNotFound
        end
      end

      context "with nil id" do
        it "raises error" do
          expect {
            fetch_product.call(nil)
          }.to raise_error ArgumentError
        end
      end
    end
  end
end
