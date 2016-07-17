require_relative "../../app"

module Shop
  RSpec.describe Shop::App do
    # http://stackoverflow.com/a/12082414
    subject(:app) { App.new! }

    describe "#load_sample_data" do
      it "adds three sample products to PRODUCTS" do
        expect {
          app.load_sample_data
        }.to change { PRODUCTS.size }.by(3)
      end
    end
  end
end
