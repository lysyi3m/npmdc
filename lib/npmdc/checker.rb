require 'json'
require 'npmdc/helpers'

module Npmdc
  class Checker
    def initialize(options)
      @options = {
        path: options[:path] || Dir.pwd,
        verbose: options[:verbose]
      }
    end

    def call
      package_json = get_package_json(@options[:path])

      if package_json
        package_json_data = parse_package_json(package_json)
        @installed_modules = get_installed_modules
      end

      if package_json_data && package_json_data.key?('dependencies')
        dependencies = package_json_data['dependencies']
        check_dependencies(dependencies)
      end

      if package_json_data && package_json_data.key?('devDependencies')
        dev_dependencies = package_json_data['devDependencies']
        check_dependencies(dev_dependencies, 'devDependencies')
      end
    end

    private

    def get_installed_modules
      modules_directory = File.join(@options[:path], 'node_modules')

      if Dir.exist?(modules_directory)
        modules = {}

        Dir.entries(modules_directory).each do |entry|
          if entry != '.' && entry != '..' and File.directory? File.join(modules_directory, entry)
            modules[entry] = File.join(modules_directory, entry)
          end
        end

        modules
      else
        message = [
          "Failed! Can't find `node_modules` folder inside '#{@options[:path]}' directory!",
          'Try running `npm install` first.'
        ].join("\n")

        puts message
        exit
      end
    end

    def get_package_json(directory)
      file_path = File.join(directory, 'package.json')

      if File.file?(file_path)
        File.read(file_path)
      else
        puts "There is no `package.json` file inside '#{directory}' directory." if @options[:verbose]
      end
    end

    def parse_package_json(json)
      begin
        JSON.parse(json)
      rescue JSON::ParserError => error
        raise error
      end
    end

    def check_dependencies(deps = {}, type = 'dependencies')
      puts "Check #{type}..." if @options[:verbose]

      missed_dependencies = []

      deps.keys.each do |dep|
        if @installed_modules.key?(dep)
          package_json = get_package_json(@installed_modules[dep])
          package_json_data = parse_package_json(package_json)
          missed_dependencies.push(dep) unless package_json_data && package_json_data['name'] == dep
        else
          missed_dependencies.push(dep)
        end
      end

      if missed_dependencies.any?
        message = [
          "Failed! Following #{type} required by your package.json file are missing or not installed properly:\n",
          missed_dependencies.map { |dep| "* #{dep}@#{deps[dep]}" },
          "\nRun `npm install` to install missing packages.",
        ].join("\n")

        puts message
        exit
      else
        puts "OK! #{pluralize(deps.length, 'dependency', 'dependencies')} checked." if @options[:verbose]
      end
    end
  end
end
