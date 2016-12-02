module Npmdc
  module Errors
    class NoNodeModulesError < StandardError; end
    class MissedPackageError < StandardError; end
    class JsonParseError < StandardError; end
    class MissedDepsError < StandardError; end
    class WrongPathError < StandardError; end
  end
end