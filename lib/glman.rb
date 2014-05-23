require "glman/kernel"
require "glman/version"
require "activesupport/dependencies"

module Glman
  extend ActiveSupport::Dependencies
  autoload_paths << File.expand_path('../', __FILE__)
end
