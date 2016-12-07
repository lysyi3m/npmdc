module Npmdc
  module Errors
    # Result Errors
    class NoNodeModulesError < StandardError; end
    class MissedPackageError < StandardError; end
    class JsonParseError < StandardError; end
    class MissedDepsError < StandardError; end
    class WrongPathError < StandardError; end

    # Configuration Errors
    class UnknownFormatter < StandardError; end
  end
end
