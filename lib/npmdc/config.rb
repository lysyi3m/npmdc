module Npmdc
  class Config
    PACKAGE_MANAGERS = %w(npm yarn).freeze
    DEPEPENDENCY_TYPES = %w(dependencies devDependencies).freeze
    ENVIRONMENTS = %w(development).freeze

    attr_accessor :color, :format, :output, :types, :environments,
                  :abort_on_failure, :package_manager, :path_to_yarn
    attr_writer :path

    def initialize
      @package_manager = 'npm'
      @path_to_yarn = nil
      @color = true
      @format = :short
      @output = STDOUT
      @types = DEPEPENDENCY_TYPES
      @environments = ENVIRONMENTS
      @abort_on_failure = false
    end

    def path
      @path ||= Dir.pwd
    end

    def path?
      instance_variable_defined?(:@path)
    end
  end
end
