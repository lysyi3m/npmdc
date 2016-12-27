module Npmdc
  class Config
    DEPEPENDENCY_TYPES = %w(dependencies devDependencies).freeze

    attr_accessor :color, :format, :output, :types, :development_only
    attr_writer :path

    def initialize
      @color = true
      @format = :short
      @output = STDOUT
      @types = DEPEPENDENCY_TYPES
      @development_only = true
    end

    def path
      @path ||= Dir.pwd
    end

    def path?
      instance_variable_defined?(:@path)
    end
  end
end
