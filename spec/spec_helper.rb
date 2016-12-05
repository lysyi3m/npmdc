$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry-byebug'

require File.expand_path("../dummy/config/environment", __FILE__)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# disable output
Npmdc.output = StringIO.new
