require 'yaml'
require 'hashie'

module Glman
  class Configuration

    def load
      File.exist?(config_file) ? Hashie::Mash.new(YAML.load_file(config_file)) : nil
    end

    def build_config(config={})
      validare_config(config)
      File.write(config_file, config.to_yaml)
    end

    def add_user_alias(opts={})
      config  = load
      aliases = config[:aliases] || {}
      aliases[opts.fetch(:alias)] = opts.fetch(:email)
      config[:aliases] = aliases
      File.write(config_file, config.to_yaml)
    end

    def clear_user_aliases
      config           = load
      config[:aliases] = {}
      File.write(config_file, config.to_yaml)
    end

    def set_user_list(users)
      config         = load
      config[:users] = users
      File.write(config_file, config.to_yaml)
    end

    private

    def validare_config(hash)
      raise ArgumentError, 'config is not hash' unless hash.kind_of?(Hash)
      raise ArgumentError, 'private_token missing in configuration' unless hash.has_key?(:private_token)
      raise ArgumentError, 'gitlab_url missing in configuration'    unless hash.has_key?(:gitlab_url)
    end

    def config_load
      Hashie::Mash.new(YAML.load_file(config_file)).tap do |config|
        validare_config(config)
      end
    end

    def config_file
      File.expand_path('.glmanrc',Dir.home)
    end
  end
end
