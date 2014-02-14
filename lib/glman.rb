require "glman/version"
require "active_support/dependencies"

module Glman
  extend ActiveSupport::Dependencies
  autoload_paths << File.expand_path('../', __FILE__)
end
