require_relative "../model/product"

module Shop
  class FetchProducts
    def call
      Shop::PRODUCTS
    end
  end
end
