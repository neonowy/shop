require "web_helper"

module Shop
  RSpec.describe "POST /basket", type: :request do
    let(:product) { Product.new(name: "Doge", price: 10) }

    before do
      clear_data

      PRODUCTS << product
      WAREHOUSE.add_product(product: product, quantity: 10)

      do_request(params)
    end

    context "with valid product in stock" do
      let(:params) { { product_id: product.id, quantity: 1 } }

      it "returns 200 HTTP code" do
        follow_redirect!

        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end
    end

    context "with valid product but try to add quantity larger than amount of product in warehouse" do
      let(:params) { { product_id: product.id, quantity: 100 } }

      it "returns 200 HTTP code" do
        follow_redirect!

        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        follow_redirect!

        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "returns div.flash.error with 'Not enough amount of product is available.'" do
        error_message = "Not enough amount of product is available."

        follow_redirect!

        expect(last_response.body).to include("<div class='flash error'>#{error_message}</div>")
      end
    end

    context "with not existing product" do
      let(:params) { { product_id: -1, quantity: 100 } }

      it "returns 404 HTTP code" do
        expect(last_response.status).to eql(404)
      end
    end

    private

    def do_request(params = {})
      post "/basket/add", params
    end
  end
end
