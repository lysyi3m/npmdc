# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'npmdc/version'

Gem::Specification.new do |spec|
  spec.name          = "npmdc"
  spec.version       = Npmdc::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Emil Kashkevich"]
  spec.email         = ["emil.kashkevich@gmail.com"]
  spec.summary       = "Check for missed dependencies of NPM packages."
  spec.description   = "Check for missed dependencies of NPM packages based on dependency list specified in package.json file."
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["npmdc"]
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "colorize"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
