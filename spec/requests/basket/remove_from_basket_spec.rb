require "web_helper"

module Shop
  RSpec.describe "POST /basket/remove", type: :request do
    let(:product) { Product.new(name: "Doge", price: 10) }
    let(:product_id) { product.id }

    before do
      clear_data

      PRODUCTS << product

      WAREHOUSE.add_product(product: product, quantity: 10)
      BASKET.add(product, 10)

      do_request(params)
    end

    context "with valid product in basket" do
      let(:params) { { product_id: product_id } }

      it "returns 200 HTTP code" do
        follow_redirect!

        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        follow_redirect!

        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "removes item from basket" do
        # Have to add it again because it was already removed in before block (do_request)
        BASKET.add(product, 10)

        expect {
          do_request(params)
        }.to change { BASKET.items.size }.by(-1)
      end
    end

    context "with valid product not in basket" do
      let(:second_product) { Product.new(name: "Doge T-Shirt", price: 10) }
      let(:params) { { product_id: second_product.id } }

      before do
        PRODUCTS << second_product
        WAREHOUSE.add_product(product: second_product, quantity: 10)

        do_request(params)
      end

      it "returns 404 HTTP code" do
        expect(last_response.status).to eql(404)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "doesn't change any of basket items" do
        expect {
          do_request(params)
        }.to_not change { BASKET.items }
      end
    end

    context "with nil product" do
      let(:params) { { product_id: -1 } }

      it "returns 404 HTTP code" do
        expect(last_response.status).to eql(404)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "doesn't change any of basket items" do
        expect {
          do_request(params)
        }.to_not change { BASKET.items }
      end
    end

    private

    def do_request(params)
      post "/basket/remove", params
    end
  end
end
