require 'yaml'
require 'hashie'

module Glman
  class ConfigManager
    class SetConfigError < StandardError; end

    def get
      File.exist?(config_file) ? load_configuration : {}
    end

    def set(hash)
      raise SetConfigError, 'argument is not kind of hash' unless hash.kind_of?(Hash)
      updated_config = get.merge(hash)

      save_configuration(updated_config)
    end

    def clear
      File.write(config_file, {}.to_yaml)
    end

    private

    def save_configuration(config)
      File.write(config_file, config.to_yaml)
    end

    def load_configuration
      Hashie::Mash.new(YAML.load_file(config_file))
    rescue
      {}
    end

    def config_file
      File.expand_path('.glmanrc',Dir.home)
    end
  end
end
