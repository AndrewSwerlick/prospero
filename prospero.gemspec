# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prospero/version'

Gem::Specification.new do |spec|
  spec.name          = "prospero"
  spec.version       = Prospero::VERSION
  spec.authors       = ["Andrew Swerlick"]
  spec.email         = ["andrew.swerlick@hbdi.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "minitest-around"

  spec.add_runtime_dependency "reform", "~> 2.0"
  spec.add_runtime_dependency 'actionpack'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'activerecord'
  spec.add_runtime_dependency 'sqlite3'
  spec.add_runtime_dependency 'railties'

end
