require 'semantic_range'
require 'npmdc/checkers/base'

module Npmdc
  module Checkers
    module Npm
      class NpmChecker < Base
        def initialize(types:, formatter:, path:)
          super(types: types, formatter: formatter, path: path)

          @dependencies_count = 0
          @missing_dependencies = Set.new
          @suspicious_dependencies = Set.new
        end

        def call
          package_json_data = package_json(path)
          types.each do |type|
            check_dependencies(package_json_data[type], type) if package_json_data[type]
          end

          if !@missing_dependencies.empty?
            raise(MissedDependencyError, dependencies: @missing_dependencies, manager: 'npm')
          end

          result_stats = "Checked #{@dependencies_count} packages. " +
                         "Warnings: #{@suspicious_dependencies.count}. " +
                         "Errors: 0. " +
                         "Everything is ok."

          output(result_stats, :success)
        end

        private

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

        def installed_modules
          @installed_modules ||= begin
            modules_directory = File.join(path, 'node_modules')
            raise(NoNodeModulesError, path: path, manager: 'npm') unless Dir.exist?(modules_directory)

            Dir.glob("#{modules_directory}/*").each_with_object({}) do |file_path, modules|
              next unless File.directory?(file_path)
              modules[File.basename(file_path)] = package_json(file_path)
            end
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
  end
end
