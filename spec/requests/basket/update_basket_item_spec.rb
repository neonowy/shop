require "web_helper"

module Shop
  RSpec.describe "PUT /basket", type: :request do
    let(:product) { Product.new(name: "Doge", price: 10) }

    before do
      clear_data

      PRODUCTS << product
      WAREHOUSE.add_product(product: product, quantity: 10)
      BASKET.add(product, 1)
    end

    context "when enough quantity in stock" do
      let(:params) { { product_id: product.id, quantity: 2 } }

      it "returns 200 HTTP code" do
        do_request(params)

        follow_redirect!

        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        do_request(params)

        follow_redirect!

        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "updates basket item" do
        expect {
          do_request(params)
        }.to change { BASKET.items.last.quantity }.from(1).to(2)
      end
    end

    context "when not enough quantity in stock" do
      let(:params) { { product_id: product.id, quantity: 50 } }

      before do
        do_request(params)

        follow_redirect!
      end

      it "returns 200 HTTP code" do
        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "returns div.flash.error with 'Not enough amount of product is available.'" do
        error_message = "Not enough amount of product is available."

        expect(last_response.body).to include("<div class='flash error'>#{error_message}</div>")
      end
    end

    context "with negative quantity param" do
      let(:params) { { product_id: product.id, quantity: -10 } }

      before do
        do_request(params)

        follow_redirect!
      end

      it "returns 200 HTTP code" do
        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "returns div.flash.error with 'Invalid quantity value.'" do
        error_message = "Invalid quantity value."

        expect(last_response.body).to include("<div class='flash error'>#{error_message}</div>")
      end
    end

    context "with not existing product" do
      let(:params) { { product_id: -1, quantity: 100 } }

      before do
        do_request(params)
      end

      it "returns 404 HTTP code" do
        expect(last_response.status).to eql(404)
      end
    end

    private

    def do_request(params = {})
      put "/basket", params
    end
  end
end
