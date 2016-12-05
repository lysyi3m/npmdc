$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'npmdc'
require 'pry-byebug'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# disable output
Npmdc.output = StringIO.new
