require 'yaml'
require 'hashie'

module Glman
  class Configuration

    def load
      File.exist?(config_file) ? Hashie::Mash.new(YAML.load_file(config_file)) : nil
    end

    def build_config(config={})
      validate_config(config)
      File.write(config_file, config.to_yaml)
    end

    def show_aliases
      load[:aliases]
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

    def set_notifications(hash)
      validate_notofy_config(hash)
      hash[:irc][:server] = 'irc.freenode.net' unless hash[:irc][:server]
      hash[:irc][:nick]   = "glman-#{Time.new.to_i}" unless hash[:irc][:nick]
      hash[:irc][:port]   = 6697 unless hash[:irc][:port]
      hash[:irc][:ssl]    = true unless hash[:irc][:ssl]
      update_notify_configuration(hash)
    end

    private

    def validate_notofy_config(hash)
      raise ArgumentError, 'config is not hash' unless hash.kind_of?(Hash)
      raise ArgumentError, 'irc missing in configuration' unless hash.has_key?(:irc)
      raise ArgumentError, 'channel missing in configuration' unless hash[:irc].has_key?(:channel)
    end

    def validate_config(hash)
      raise ArgumentError, 'config is not hash' unless hash.kind_of?(Hash)
      raise ArgumentError, 'private_token missing in configuration' unless hash.has_key?(:private_token)
      raise ArgumentError, 'gitlab_url missing in configuration'    unless hash.has_key?(:gitlab_url)
    end

    def update_notify_configuration(hash)
      config     = load
      notify_cfg = load.fetch(:notify_cfg, {})
      notify_cfg.merge(hash)
      config[:notify_cfg] = notify_cfg
      File.write(config_file, config.to_yaml)
    end

    def config_load
      Hashie::Mash.new(YAML.load_file(config_file)).tap do |config|
        validate_config(config)
      end
    end

    def config_file
      File.expand_path('.glmanrc',Dir.home)
    end
  end
end
