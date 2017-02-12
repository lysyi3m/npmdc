# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'npmdc/version'

Gem::Specification.new do |spec|
  spec.name          = 'npmdc'
  spec.version       = Npmdc::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Emil Kashkevich']
  spec.email         = ['emil.kashkevich@gmail.com']
  spec.summary       = 'Check for missed dependencies of NPM packages.'
  spec.description   = 'Check for missed dependencies of NPM packages based on'\
                       ' dependency list specified in package.json file.'
  spec.homepage      = 'https://github.com/lysyi3m/npmdc'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['npmdc']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency 'thor',           '> 0.18'
  spec.add_dependency 'colorize',       '~> 0.8.1'
  spec.add_dependency 'semantic_range', '~> 1.0'

  spec.add_development_dependency 'bundler',  '~> 1.13'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'rspec',    '~> 3.0'
  spec.add_development_dependency 'rails',    '>= 4.2'
  spec.add_development_dependency 'pry-byebug'
end
