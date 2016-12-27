require 'npmdc/core/string_strip_heredoc'

module Npmdc
  class Railtie < Rails::Railtie # :nodoc:
    using StringStripHeredoc

    # Make config accessible through application config
    config.npmdc = Npmdc.config

    initializer "npmdc.initialize" do
      Npmdc.config.path = Rails.root unless Npmdc.config.path?
    end

    initializer "npmdc.development_only" do
      if config.npmdc.development_only == true && !Rails.env.development?
        abort <<-END.strip_heredoc
          Npmdc is trying to be activated in the #{Rails.env} environment.
          Probably, this is a mistake. To ensure it's only activated in development
          mode, move it to the development group of your Gemfile:
              gem 'npmdc', group: :development
          If you still want to run it in the #{Rails.env} environment (and know
          what you are doing), put this in your Rails application
          configuration:
              config.npmdc.development_only = false
        END
      end
    end

    initializer "npmdc.call" do
      Npmdc.call
    end
  end
end
