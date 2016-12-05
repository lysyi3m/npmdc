$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'npmdc'
require 'pry-byebug'

RSpec.configure do |config|
  config.before(:each) do
    $stdout = StringIO.new
  end

# disable output
Npmdc.output = StringIO.new
