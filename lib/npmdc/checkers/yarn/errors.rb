module Npmdc
  module Checkers
    module Yarn
      module Errors
        class NoYarnLockFileError < Npmdc::Checkers::Errors::CheckerError
          define_critical!

          def banner
            "No lockfile in this directory. Run `yarn install` to generate one."
          end
        end

        class YarnNotInstalledError < Npmdc::Checkers::Errors::CheckerError
          define_critical!

          def banner
            "Failed to find `#{options.fetch(:yarn_command)}`. Check that `yarn` is installed, please."
          end
        end
      end
    end
  end
end
