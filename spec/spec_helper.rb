require "simplecov"

ENV["RACK_ENV"] = "test"

SimpleCov.start do
  add_filter "/spec"
end

module SpecHelper
  def clear_data
    Shop::PRODUCTS.clear
    Shop::WAREHOUSE.statuses.clear
    Shop::BASKET.items.clear
  end
end

RSpec.configure do |config|
  config.disable_monkey_patching!
  # config.warnings = true

  config.include SpecHelper

  config.order = :random
  Kernel.srand config.seed
end
