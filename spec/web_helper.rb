require "spec_helper"
require "rack/test"

require_relative "../app"

module AppHelper
  def app
    Shop::App
  end

  def clear_data
    Shop::PRODUCTS.clear
    Shop::WAREHOUSE.statuses.clear
    Shop::BASKET.items.clear
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include AppHelper, type: :request
end
