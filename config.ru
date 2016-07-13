require "bundler/setup"
require_relative "./app"

use Rack::Static, root: "public"

run Shop::App

Rack::Handler::WEBrick.run(
  Shop::App.new,
  port: 9292,
  static: true,
  public_folder: "public",
  views: "views"
)
