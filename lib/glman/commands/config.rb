require "irc-notify"

module Glman
  module Commands
    class Config
      attr_reader :config_manager
      def initialize(opts={})
        @config_manager = opts.fetch(:config_manager)
      end

      def show_configuration(params=[])
        get_configuration_key(params).tap do |conf|
          dp conf.blank? ? "No configuration yet" : conf
        end
      end

      def set_gitlab(gitlab_url, private_token)
        gitlab = { gitlab_url: gitlab_url, private_token: private_token }
        set(gitlab: gitlab)
      end

      def set_alias(email, _alias)
        aliases = get[:aliases] || {}
        aliases[_alias.to_sym] = email
        configuration.set(aliases: aliases)
      end

      def delete_alias

      end

      def set_users
      end

      def clear_users

      end

      private

      def get_configuration_key(params)
        return config_manager.get if params.blank?
        config_manager.get.tap do |conf|
          params.compact.each do |key|
            conf = conf[key.to_sym] || {}
          end
        end
      end
    end
  end
end