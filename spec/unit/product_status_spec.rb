require_relative "../../lib/model/product_status.rb"
require_relative "../../lib/model/product.rb"

module Shop
  RSpec.describe Shop::ProductStatus do
    subject(:product_status) { ProductStatus.new(product: product, quantity: 10) }
    let(:product) { Product.new(name: "Ball", price: 10) }

    describe "#product" do
      it "has proper product" do
        expect(product_status.product).to eql(product)
      end
    end

    describe "#quantity" do
      it "has proper quantity" do
        expect(product_status.quantity).to eql(10)
      end
    end
  end
end
