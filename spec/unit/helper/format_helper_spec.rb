require "./lib/helper/format_helper"

module Shop
  RSpec.describe Shop::FormatHelper do
    include FormatHelper

    describe "#format_price" do
      it "returns proper formatted price" do
        expect(format_money(1499 * 0.45)).to eql("674.55")
      end

      it "doesn't show .00 decimal places" do
        expect(format_money(100)).to eql("100")
      end
    end
  end
end
