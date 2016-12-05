module Npmdc
  class Config
    attr_accessor :color, :format, :output
    attr_writer :path

    def initialize
      @color = true
      @format = :short
      @output = STDOUT
    end

    def path
      @path ||= Dir.pwd
    end

    def path?
      instance_variable_defined?(:@path)
    end
  end
end
