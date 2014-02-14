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
  spec.add_development_dependency "rake"
  spec.add_dependency "httpclient"
  spec.add_dependency "executable"
  spec.add_dependency "json"
  spec.add_dependency "active_support"
  spec.add_dependency "awesome_print"
  spec.add_dependency "hashie"
  end
