require "web_helper"

module Shop
  RSpec.describe "GET /basket", type: :request do
    context "with empty basket" do
      before do
        clear_data
        do_request
      end

      it "returns 200 HTTP code" do
        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "returns h1 element 'Your basket'" do
        expect(last_response.body).to include("<h1>Your basket</h1>")
      end
    end

    context "with items in basket" do
      let(:first_product) { Product.new(name: "Doge", price: 1000) }
      let(:second_product) { Product.new(name: "Doge T-Shirt", price: 49) }

      before do
        clear_data

        PRODUCTS << first_product
        PRODUCTS << second_product

        WAREHOUSE.add_product(product: first_product, quantity: 10)
        WAREHOUSE.add_product(product: second_product, quantity: 10)

        BASKET.add(first_product, 1)
        BASKET.add(second_product, 4)

        do_request
      end

      it "returns 200 HTTP code" do
        expect(last_response.status).to eql(200)
      end

      it "returns valid HTML Content-Type" do
        expect(last_response.headers["Content-Type"]).to include("text/html")
      end

      it "returns td elements with items names and quantity" do
        expect(last_response.body).to include("<td>1x Doge</td>")
        expect(last_response.body).to include("<td>4x Doge T-Shirt</td>")
      end

      it "returns p element with basket total price" do
        expect(last_response.body).to include("<p>1471.08 zł</p>")
      end

      it "returns p element with basket total brutto" do
        expect(last_response.body).to include("<p>1196 zł</p>")
      end
    end

    private

    def do_request
      get "/basket"
    end
  end
end
