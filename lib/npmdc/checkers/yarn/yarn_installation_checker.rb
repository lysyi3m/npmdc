module Npmdc
  class YarnInstallationChecker
    attr_reader :yarn_command

    def initialize(yarn_command)
      @yarn_command = yarn_command
    end

    def check_yarn_is_installed
      if yarn_command == 'yarn'
        check_yarn_is_installed_default
      else
        check_yarn_is_installed_on_the_given_path
      end
    end

    private

    def os_extensions
      ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    end

    def check_yarn_is_installed_on_the_given_path
      os_extensions.each do |ext|
        yarn = "#{yarn_command}#{ext}"
        return true if File.executable?(yarn) && !File.directory?(yarn)
      end
      raise(Npmdc::Errors::YarnNotInstalledError, yarn_command: yarn_command)
    end

    def check_yarn_is_installed_default
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        os_extensions.each do |ext|
          yarn = File.join(path, "#{yarn_command}#{ext}")
          return true if File.executable?(yarn) && !File.directory?(yarn)
        end
      end
      raise(Npmdc::Errors::YarnNotInstalledError, yarn_command: yarn_command)
    end
  end
end
