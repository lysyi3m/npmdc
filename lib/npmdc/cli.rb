require 'thor'
require 'npmdc'

module Npmdc
  class Cli < Thor
    default_task :check

    desc 'check', 'Run check'
    method_option :path, desc: 'Path to package.json config'
    method_option :color, desc: 'Enable color', type: :boolean, default: true
    method_option :types, aliases: [:t],
                          desc: 'types for check',
                          type: :array,
                          default: Npmdc::Config::DEPEPENDENCY_TYPES
    method_option :format, aliases: [:f],
                           desc: "Output format,
                           possible values: #{Npmdc::Formatter::FORMATTERS.keys.join(", ")}"

    def check
      Npmdc.call(options)
    end

    map %w[--version -v] => :__print_version
    desc '--version, -v', 'Print gem version'
    def __print_version
      puts Npmdc::VERSION
    end
  end
end
