require 'yaml'
require 'hashie'

module Glman
  class ConfigManager

    def get
      File.exist?(config_file) ? load_configuration : {}
    end

    def set(hash)
      raise ConfigurationUpdateError.new unless hash.kind_of?(Hash)
      updated_config = get.merge(hash)
      validate_config(updated_config)

      save_configuration(updated_config)
    end

    def clear
      File.write(config_file, {}.to_yaml)
    end

    def valid?
      validate_config(get)
      true
    rescue
      false
    end

    private

    def validate_config(hash)
      raise ArgumentError, 'config is not hash' unless hash.kind_of?(Hash)
      raise ArgumentError, 'gitlab missing in configuration' unless hash.has_key?(:gitlab)
      gitlab_hash = hash[:gitlab]
      raise ArgumentError, 'gitlab#private_token missing in configuration' unless gitlab_hash.has_key?(:private_token)
      raise ArgumentError, 'gitlab#url missing in configuration'    unless gitlab_hash.has_key?(:url)
    end

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
