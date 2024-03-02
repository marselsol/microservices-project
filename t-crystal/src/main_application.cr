require "kemal"
require "./hello_controller"

Kemal.config do |config|
  config.port = 8099
end

Kemal.run
