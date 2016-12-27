$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'pry-byebug'

require 'npmdc/core/string_strip_heredoc'
require 'npmdc'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# disable output
Npmdc.config.output = StringIO.new
