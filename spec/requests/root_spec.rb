require "web_helper"

module Shop
  RSpec.describe "GET /", type: :request do
    let(:product) { Product.new(name: "Doge", price: 1000) }

    before do
      clear_data

      PRODUCTS << product
      WAREHOUSE.add_product(product: product, quantity: 10)

      do_request
    end

    it "returns 200 HTTP code" do
      expect(last_response.status).to eql(200)
    end

    it "returns valid HTML Content-Type" do
      expect(last_response.headers["Content-Type"]).to include("text/html")
    end

    it "returns a element with 'Such Shop'" do
      expect(last_response.body).to include("<a href=\"/\" class=\"brand\">Such Shop</a>")
    end

    private

    def do_request
      get "/"
    end
  end
end
