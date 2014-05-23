# encoding: utf-8

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glman/version'

Gem::Specification.new do |spec|
  spec.name          = "glman"
  spec.version       = Glman::VERSION
  spec.authors       = ["Paweł Niemczyk"]
  spec.email         = ["pniemczyk@o2.pl"]
  spec.description   = %q{Git Lab Manager}
  spec.summary       = %q{Git Lab Manager}
  spec.homepage      = "https://github.com/pniemczyk/glman"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "httpclient", "~> 2.3"
  spec.add_dependency "executable", "~> 1.2"
  spec.add_dependency "json", "~> 1.8"
  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "awesome_print", "~> 1.2"
  spec.add_dependency "hashie", "~> 2.1"
  spec.add_dependency "irc-notify", "~> 0"
  end
