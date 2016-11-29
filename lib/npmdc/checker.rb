require 'colorize'
require 'json'

class Npmdc::Checker
  def initialize(options)
    puts options
    @working_directory = options[:path] || Dir.pwd
  end

  def call
    package_json = get_package_json(@working_directory)
    package_json_data = parse_package_json(package_json)
    @installed_modules = get_installed_modules

    if package_json_data.key?('dependencies')
      dependencies = package_json_data['dependencies']
      check_dependencies(dependencies)
    end

    if package_json_data.key?('devDependencies')
      dev_dependencies = package_json_data['devDependencies']
      check_dependencies(dev_dependencies, 'devDependencies')
    end
  end

  private

  def get_installed_modules
    modules_directory = File.join(@working_directory, 'node_modules')

    if Dir.exists?(modules_directory)
      modules = {}

      Dir.entries(modules_directory).each do |entry|
        if entry != '.' && entry != '..' and File.directory? File.join(modules_directory, entry)
          modules[entry] = File.join(modules_directory, entry)
        end
      end

      modules
    else
      message = [
        "There is no `node_modules` folder inside '#{@working_directory}' directory.".colorize(:red),
        "Try running `npm install` first.".colorize(:yellow)
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
      puts "There is no `package.json` file inside '#{directory}' directory.".colorize(:red)
      exit
    end
  end

  def parse_package_json(json)
    begin
      JSON.parse(json)
    rescue JSON::ParserError => e
      raise "Failed to parse package.json file."
    end
  end

  def check_dependencies(deps = {}, type = 'dependencies')
    missed_dependencies = []

    deps.keys.each do |name|
      missed_dependencies.push(name) unless @installed_modules.key?(name)
    end

    if missed_dependencies.any?
      message = [
        "Following #{type} required by your package.json file are missing:".colorize(:red),
        missed_dependencies.map { |dep| "* #{dep}@#{deps[dep]}".colorize(:red) },
        "Run `npm install` to install missing packages.".colorize(:yellow),
      ].join("\n")

      puts message
      exit
    end
  end
end
