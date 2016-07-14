require "web_helper"

module Shop
  RSpec.describe "GET /basket/remove/:id", type: :request do
    context "with valid product in basket" do
      let(:product) { Product.new(name: "Doge", price: 10) }
      let(:product_id) { product.id }

      before do
        clear_data

        PRODUCTS << product

        WAREHOUSE.add_product(product: product, quantity: 10)
        BASKET.add(product, 10)
      end

      it "returns 200 HTTP code" do
        do_request(product_id)
        follow_redirect!

        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        do_request(product_id)

        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "decreases basket item quantity by one" do
        expect {
          do_request(product_id)
        }.to change { BASKET.items.last.quantity }.by(-1)
      end
    end

    context "with valid product not in basket" do
      let(:product) { Product.new(name: "Doge Shirt", price: 10) }
      let(:product_id) { product.id }

      before do
        clear_data

        PRODUCTS << product
        WAREHOUSE.add_product(product: product, quantity: 10)

        do_request(product_id)
      end

      it "returns 404 HTTP code" do
        expect(last_response.status).to eql(404)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "doesn't change any of basket items" do
        expect {
          do_request(product_id)
        }.to_not change { BASKET.items }
      end
    end

    context "with nil product" do
      let(:product_id) { -1 }

      before do
        do_request(product_id)
      end

      it "returns 404 HTTP code" do
        expect(last_response.status).to eql(404)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "doesn't change any of basket items" do
        expect {
          do_request(product_id)
        }.to_not change { BASKET.items }
      end
    end

    private

    def do_request(id)
      get "/basket/remove/#{id}"
    end
  end
end
