require "sinatra/base"
require "sinatra/flash"

Dir["./lib/**/*.rb"].each { |file| require file }

module Shop
  PRODUCTS = []
  WAREHOUSE = Warehouse.new
  BASKET = Basket.new

  class App < Sinatra::Base
    require "sinatra/reloader" if development?

    enable :sessions
    register Sinatra::Flash

    def initialize
      super

      if self.class.development?
        load_sample_data
      end

      products = FetchProducts.new.call
      warehouse = FetchWarehouse.new.call

      products.each do |product|
        warehouse.add_product(product: product, quantity: 10)
      end
    end

    get "/" do
      @warehouse = FetchWarehouse.new.call
      @products = FetchProducts.new.call

      erb :"product/index"
    end

    get "/products/:id" do |id|
      @warehouse = FetchWarehouse.new.call

      begin
        @product = FetchProduct.new.call(id.to_i)

        erb :"product/show"
      rescue ProductNotFound
        halt 404
      end
    end

    get "/basket" do
      @basket = FetchBasket.new.call

      erb :"basket/show"
    end

    post "/basket" do
      begin
        AddToBasket.new(params).call
      rescue QuantityLevelError
        flash[:error] = "Not enough amount of product is available."
      rescue ProductNotFound
        halt 404
      end

      redirect back
    end

    get "/basket/remove/:id" do
      begin
        RemoveFromBasket.new(params).call
      rescue ProductNotFound
        halt 404
      rescue NotInBasket
        halt 404
      end

      redirect "/basket"
    end

    def load_sample_data
      PRODUCTS << Product.new(name: "Doge", image: "doge.jpg", price: 1500, discount: 0.20)
      PRODUCTS << Product.new(name: "Doge Sticker", image: "doge-sticker.jpg", price: 2)
      PRODUCTS << Product.new(name: "Doge T-Shirt", image: "doge-tshirt.jpg", price: 49)
    end
  end
end
