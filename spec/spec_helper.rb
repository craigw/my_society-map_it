require 'simplecov'
require 'simplecov-rcov'
require 'pry'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

require 'my_society-map_it'

RSpec.configure do |config|

  config.order = "random"

end