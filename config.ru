require "bundler/setup"
require_relative "./app"

use Rack::Static, root: "public"

run Shop::App
