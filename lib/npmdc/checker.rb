require 'colorize'
require 'json'
require 'active_support/inflector'
require 'npmdc/formatter'
require 'npmdc/errors'
require 'forwardable'

module Npmdc
  class Checker
    extend Forwardable
    include Npmdc::Errors

    attr_accessor :path, :formatter

    DEPENDENCIES = %w(dependencies devDependencies).freeze

    def initialize(options)
      @path = options['path'] || Dir.pwd
      @formatter = Npmdc::Formatter.(options)
      @dependencies_count = 0
      @missed_dependencies = []
    end

    delegate [:output, :dep_output, :check_start_output, :check_finish_output] => :formatter

    def call
      begin
        success = false
        package_json_data = package_json(@path)
        DEPENDENCIES.each do |dep|
          if package_json_data[dep]
            begin
              check_dependencies(package_json_data[dep], dep)
            end
          end
        end

      rescue NoNodeModulesError => e
        output("Failed! Can't find `node_modules` folder inside '#{e.message}' directory!")
        output("\nRun `npm install` to install missing packages.", :warn)

      rescue WrongPathError => e
        output("There is no '#{e.message}' directory.")

      rescue MissedPackageError => e
        output("There is no `package.json` file inside '#{e.message}' directory.")

      rescue JsonParseError => e
        output("Can't parse JSON file #{e.message}")
      else
        success = true unless !@missed_dependencies.empty?
      ensure
        if !@missed_dependencies.empty?
          output("Following dependencies required by your package.json file are missing or not installed properly:")
          @missed_dependencies.uniq.each do |dep|
            output("  * #{dep}")
          end
          output("\nRun `npm install` to install #{@missed_dependencies.uniq.count} missed packages.", :warn)
        elsif success
          output("#{@dependencies_count} #{"package".pluralize(@dependencies_count)} checked. Everything is ok.", :success)
        end

        return success
      end
    end

    private

    def installed_modules
      @installed_modules ||= begin
        modules_directory = File.join(@path, 'node_modules')
        raise NoNodeModulesError, @path unless Dir.exist?(modules_directory)

        Dir.entries(modules_directory).each_with_object({}) do |entry, modules|
          if entry != '.' && entry != '..' and File.directory? File.join(modules_directory, entry)
            modules[entry] = package_json(File.join(modules_directory, entry))
          end
        end
      end
    end

    def package_json(directory, filename = 'package.json')
      raise WrongPathError, directory unless Dir.exist?(directory)
      file_path = File.join(directory, filename)
      raise MissedPackageError, directory unless File.file?(file_path)

      begin
        JSON.parse(File.read(file_path))
      rescue JSON::ParserError
        raise JsonParseError, file_path
      end
    end

    def check_dependencies(deps = {}, type)
      installed_modules
      check_start_output(type)
      deps.keys.each do |dep|
        @dependencies_count += 1
        status = valid_dependency?(dep) ? :success : :failure
        @missed_dependencies.push("#{dep}@#{deps[dep]}") unless valid_dependency?(dep)
        dep_output(dep, status)
      end
      check_finish_output
    end

    def valid_dependency?(dep)
      !!installed_modules[dep]
    end
  end
end
