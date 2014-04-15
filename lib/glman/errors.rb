require 'yaml'
require 'hashie'

module Glman
  module Errors
    class ConfigurationError < StandardError; end
    class ConfigurationUpdateError < StandardError; end
  end
end
