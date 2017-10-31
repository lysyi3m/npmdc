require 'npmdc/errors'

module Npmdc
  class ModulesDirectory
    include Npmdc::Errors

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def basename
      File.basename(path)
    end

    def scoped?
      basename.start_with?('@')
    end

    def valid_directories
      directories.select { |d| d.package_json_file.exists? || d.scoped? }
    end

    def package_json_file
      self.class.new(File.join(path, 'package.json'))
    end

    def package_json
      raise(WrongPathError, directory: path) unless Dir.exist?(path)
      raise(MissedPackageError, directory: path) unless package_json_file.exists?

      path = package_json_file.path
      begin
        JSON.parse(File.read(path))
      rescue JSON::ParserError
        raise(JsonParseError, path: path)
      end
    end

    def directory?
      File.directory?(path)
    end

    def exists?
      File.file?(path)
    end

    private

    def files
      Dir.glob("#{path}/*").map { |file_path| self.class.new(file_path) }
    end

    def directories
      files.select(&:directory?)
    end
  end
end
