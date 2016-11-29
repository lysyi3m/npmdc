require 'thor'
require 'npmdc'

module Npmdc
  class Cli < Thor
    class_option 'verbose', type: :boolean, desc: 'Enable verbose output mode', aliases: '-V'
    default_task :check

    desc 'check', 'Run check'
    option :path
    def check
      Npmdc::Checker.new(options).call
    end

    map %w[--version -v] => :__print_version
    desc '--version, -v', 'Print gem version'
    def __print_version
      puts Npmdc::VERSION
    end
  end
end
