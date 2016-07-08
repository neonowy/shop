require_relative "../../lib/invoice"
require_relative "../../lib/warehouse"
require_relative "../../lib/basket"
require_relative "../../lib/product"

RSpec.describe Invoice do
  subject(:invoice) { Invoice.new(buyer: buyer, basket: basket) }

  let(:buyer) { "Jan Kowalski" }
  let(:warehouse) { Warehouse.new }
  let(:basket) { Basket.new(warehouse) }

  describe "#get_invoice" do
    before do
      first_product = Product.new(name: "Ball", price: 30, discount: 0.5)
      second_product = Product.new(name: "Coca-Cola 2l", price: 5.50)

      warehouse.add_product(product: first_product, quantity: 10)
      warehouse.add_product(product: second_product, quantity: 10)

      6.times { basket.add(first_product) }
      2.times { basket.add(second_product) }
    end

    it "returns proper invoice string" do
      invoice_text = ""

      invoice_text += "Rachunek dla:\n"
      invoice_text += "Jan Kowalski\n"
      invoice_text += "------------------\n\n"
      invoice_text += "1. Ball 6szt. x 15.00 PLN = 90.00 PLN\n"
      invoice_text += "2. Coca-Cola 2l 2szt. x 5.50 PLN = 11.00 PLN\n\n"
      invoice_text += "------------------\n"
      invoice_text += "  Suma: 101.00 PLN\n"
      invoice_text += " z VAT: 124.23 PLN\n"

      expect(invoice.get_invoice).to eq(invoice_text)
    end
  end
end
