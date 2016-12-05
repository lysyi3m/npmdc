require 'colorize'
require 'json'
require 'npmdc/formatter'
require 'npmdc/errors'
require 'forwardable'

module Npmdc
  class Checker
    extend Forwardable
    include Npmdc::Errors

    attr_reader :path, :formatter

    DEPENDENCIES = %w(dependencies devDependencies).freeze

    def initialize(options)
      @path = options['path'] || Dir.pwd
      @formatter = Npmdc::Formatter.(options)
      @dependencies_count = 0
      @missing_dependencies = Set.new
    end

    delegate [:output, :dep_output, :check_start_output, :check_finish_output] => :formatter

    def call
      begin
        success = false
        package_json_data = package_json(path)

        DEPENDENCIES.each do |dep|
          check_dependencies(package_json_data[dep], dep) if package_json_data[dep]
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
        success = true unless !@missing_dependencies.empty?
      ensure
        if !@missing_dependencies.empty?
          output("Following dependencies required by your package.json file are missing or not installed properly:")
          @missing_dependencies.each do |dep|
            output("  * #{dep}")
          end
          output("\nRun `npm install` to install #{@missing_dependencies.size} missing packages.", :warn)
        elsif success
          output("Checked #{@dependencies_count} packages. Everything is ok.", :success)
        end
      end

      success
    end

    private

    def installed_modules
      @installed_modules ||= begin
        modules_directory = File.join(path, 'node_modules')
        raise NoNodeModulesError, path unless Dir.exist?(modules_directory)

        Dir.glob("#{modules_directory}/*").each_with_object({}) do |file_path, modules|
          next unless File.directory?(file_path)
          modules[File.basename(file_path)] = package_json(file_path)
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

    def check_dependencies(deps, type)
      check_start_output(type)
      deps.each_key do |dep|
        @dependencies_count += 1
        check_dependency(dep, deps[dep])
      end
      check_finish_output
    end

    def check_dependency(dep, version)
      if installed_modules[dep]
        dep_output(dep, :success)
      else
        @missing_dependencies << "#{dep}@#{version}"
        dep_output(dep, :failure)
      end
    end
  end
end
