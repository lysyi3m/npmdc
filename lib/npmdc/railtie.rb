require 'npmdc'

module Npmdc
  class Railtie < Rails::Railtie # :nodoc:
    # Make config accessible through application config
    config.npmdc = Npmdc.config

    initializer "npmdc.initialize" do
      Npmdc.config.path = Rails.root unless Npmdc.config.path?
    end

    initializer "npmdc.call" do
      Npmdc.call
    end
  end
end
