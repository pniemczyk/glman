require 'yaml'
require 'hashie'

module Glman
  class ConfigManager
    class SetConfigError < StandardError; end
    class BaseConfigValidationError < StandardError; end

    def get
      File.exist?(config_file) ? load_configuration : {}
    end

    def set(hash)
      raise SetConfigError, 'argument is not kind of hash' unless hash.kind_of?(Hash)
      updated_config = get.merge(hash)
      base_config_validate(updated_config)

      save_configuration(updated_config)
    end

    def clear
      File.write(config_file, {}.to_yaml)
    end

    def valid?
      base_config_validate(get)
      true
    rescue
      false
    end

    private

    def base_config_validate(hash)
      raise BaseConfigValidationError, 'argument is not kind of hash' unless hash.kind_of?(Hash)
      raise BaseConfigValidationError, 'gitlab key missing' unless hash.has_key?(:gitlab)
      gitlab_hash = hash[:gitlab]
      raise BaseConfigValidationError, 'gitlab#private_token key missing' unless gitlab_hash.has_key?(:private_token)
      raise BaseConfigValidationError, 'gitlab#url key missing'    unless gitlab_hash.has_key?(:url)
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
