require "web_helper"

module Shop
  RSpec.describe "GET /products/:id", type: :request do
    let(:price) { 1000 }

    context "without existing product" do
      before do
        do_request(-1)
      end

      it "returns 404 HTTP code" do
        expect(last_response.status).to eql(404)
      end
    end

    context "with an existing product" do
      context "in stock" do
        let(:product) { Product.new(name: "Doge", price: price) }

        before do
          PRODUCTS << product
          WAREHOUSE.add_product(product: product, quantity: 1)

          do_request(product.id)
        end

        it "returns h2 element with product price" do
          expect(last_response.body).to include("<h2 class=\"product-price\">#{price} zł</h2>")
        end
      end

      context "out of stock" do
        let(:product) { Product.new(name: "Doge 2", price: price) }

        before do
          PRODUCTS << product
          WAREHOUSE.add_product(product: product, quantity: 0)

          do_request(product.id)
        end

        it "returns h2 element 'OUT OF STOCK'" do
          expect(last_response.body).to include("<h2 class=\"product-price\">OUT OF STOCK</h2>")
        end
      end
    end

    private

    def do_request(id)
      get "/products/#{id}"
    end
  end
end
