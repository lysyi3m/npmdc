require 'colorize'
require 'json'
require 'forwardable'
require 'semantic_range'
require 'npmdc/formatter'
require 'npmdc/errors'
require 'npmdc/modules_directory'

module Npmdc
  class Checker
    extend Forwardable
    include Npmdc::Errors

    attr_reader :path, :formatter, :all_types

    def initialize(options)
      @path = options.fetch('path', Npmdc.config.path)
      @all_types = options.fetch('types', Npmdc.config.types)
      @abort_on_failure = options.fetch(
        'abort_on_failure', Npmdc.config.abort_on_failure
      )
      @formatter = Npmdc::Formatter.call(options)
      @dependencies_count = 0
      @missing_dependencies = Set.new
      @suspicious_dependencies = Set.new
    end

    delegate %i[
      output error_output dep_output
      check_start_output check_finish_output
    ] => :formatter

    def call
      types.each do |dep|
        check_start_output(dep)
        check_dependencies(package_data[dep])
        check_finish_output
      end

      unless @missing_dependencies.empty?
        raise(MissedDependencyError, dependencies: @missing_dependencies)
      end

      output_stats

      true
    rescue CheckerError => e
      error_output(e)

      exit(1) if @abort_on_failure && e.class.critical?

      false
    end

    private

    def package_data
      @package_data ||= ModulesDirectory.new(path).package_json
    end

    def types
      all_types.select { |type| package_data[type].present? }
    end

    # TODO: move to formatter class
    def output_stats
      result_stats = "Checked #{@dependencies_count} packages. " \
                     "Warnings: #{@suspicious_dependencies.count}. " \
                     "Errors: #{@missing_dependencies.count}. " \
                     'Everything is ok.'

      output(result_stats, :success)
    end

    def modules_directory_path
      modules_directory = File.join(path, 'node_modules')
      raise(NoNodeModulesError, path: path) unless Dir.exist?(modules_directory)
      modules_directory
    end

    def installed_modules
      @installed_modules ||=
        ModulesDirectory.new(modules_directory_path).valid_directories.each_with_object({}) do |module_directory, modules|
          if module_directory.scoped?
            module_directory.valid_directories.map do |scoped_module_directory|
              modules["#{module_directory.basename}/#{scoped_module_directory.basename}"] = scoped_module_directory.package_json
            end
          else
            modules[module_directory.basename] = module_directory.package_json
          end
        end
    end

    def check_dependencies(deps)
      deps.each_key do |dep|
        @dependencies_count += 1

        if SemanticRange.valid_range(deps[dep])
          check_dependency(dep, deps[dep])
        else
          @suspicious_dependencies << "#{dep}@#{deps[dep]}"
          dep_output("npmdc cannot check package '#{dep}' (#{deps[dep]})", :warn)
        end
      end
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
      current_version = installed_module['version']

      if !SemanticRange.valid(current_version)
        @missing_dependencies << "#{dep}@#{version}"
        dep_output(dep, :failure)
      elsif SemanticRange.satisfies(current_version, version)
        dep_output(dep, :success)
      else
        @missing_dependencies << "#{dep}@#{version}"
        dep_output("#{dep} expected version '#{version}' but got '#{current_version}'", :failure)
      end
    end
  end
end
