require 'npmdc'

module Npmdc
  class Engine < Rails::Engine # :nodoc:
    # Make config accessible through application config
    config.npmdc = Npmdc.config

    initializer "npmdc.load_hook" do |_app|
      Npmdc.config.path = Rails.root unless Npmdc.config.path?
      Npmdc.call
    end
  end
end
