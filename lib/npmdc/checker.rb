require 'colorize'
require 'json'
require 'forwardable'
require 'semantic_range'
require 'npmdc/formatter'
require 'npmdc/errors'

module Npmdc
  class Checker
    extend Forwardable
    include Npmdc::Errors

    attr_reader :path, :formatter, :types

    def initialize(options)
      @path = options.fetch('path', Npmdc.config.path)
      @types = options.fetch('types', Npmdc.config.types)
      @abort_on_failure = options.fetch('abort_on_failure', Npmdc.config.abort_on_failure)
      @formatter = Npmdc::Formatter.(options)
      @dependencies_count = 0
      @missing_dependencies = Set.new
      @suspicious_dependencies = Set.new
    end

    delegate [
      :output, :error_output, :dep_output,
      :check_start_output, :check_finish_output
    ] => :formatter

    def call
      package_json_data = package_json(path)
      @types.each do |dep|
        check_dependencies(package_json_data[dep], dep) if package_json_data[dep]
      end

      if !@missing_dependencies.empty?
        raise(MissedDependencyError, dependencies: @missing_dependencies)
      end

      result_stats = "Checked #{@dependencies_count} packages. " +
                     "Warnings: #{@suspicious_dependencies.count}. " +
                     "Errors: #{@missing_dependencies.count}. " +
                     "Everything is ok."

      output(result_stats, :success)

      true
    rescue CheckerError => e
      error_output(e)

      exit(1) if @abort_on_failure && e.class.critical?

      false
    end

    private

    def installed_modules
      @installed_modules ||= begin
        modules_directory = File.join(path, 'node_modules')
        raise(NoNodeModulesError, path: path) unless Dir.exist?(modules_directory)

        Dir.glob("#{modules_directory}/*").each_with_object({}) do |file_path, modules|
          module_package_json_file = File.join(file_path, 'package.json')

          next if !File.directory?(file_path) || !File.file?(module_package_json_file)

          modules[File.basename(file_path)] = package_json(file_path)
        end
      end
    end

    def package_json(directory, filename = 'package.json')
      raise(WrongPathError, directory: directory) unless Dir.exist?(directory)

      path = File.join(directory, filename)
      raise(MissedPackageError, directory: directory) unless File.file?(path)

      begin
        JSON.parse(File.read(path))
      rescue JSON::ParserError
        raise(JsonParseError, path: path)
      end
    end

    def check_dependencies(deps, type)
      check_start_output(type)

      deps.each_key do |dep|
        @dependencies_count += 1

        if SemanticRange.valid_range(deps[dep])
          check_dependency(dep, deps[dep])
        else
          @suspicious_dependencies << "#{dep}@#{deps[dep]}"
          dep_output("npmdc cannot check package '#{dep}' (#{deps[dep]})", :warn)
        end
      end

      check_finish_output
    end

    def check_dependency(dep, version)
      installed_module = installed_modules[dep]

      if installed_module
        check_version(installed_module, dep, version)
      else
        @missing_dependencies << "#{dep}@#{version}"
        dep_output(dep, :failure)
      end
    end

    def check_version(installed_module, dep, version)
      if !installed_module.key?('version') || !SemanticRange.valid(installed_module['version'])
        @missing_dependencies << "#{dep}@#{version}"
        dep_output(dep, :failure)
      elsif SemanticRange.satisfies(installed_module['version'], version)
        dep_output(dep, :success)
      else
        @missing_dependencies << "#{dep}@#{version}"
        dep_output("#{dep} expected version '#{version}' but got '#{installed_module['version']}'", :failure)
      end
    end
  end
end
