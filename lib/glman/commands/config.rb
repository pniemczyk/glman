require "irc-notify"

module Glman
  module Commands
    class Config
      attr_reader

      def initialize(opts={})
        @config = opts.fetch(:config)
      end

      def config(params=[])
        return display_conf if params.blank?
        display_conf(get_configuration_key(params))
      end

      def set_gitlab(gitlab_url, private_token)
        gitlab = { gitlab_url: gitlab_url, private_token: private_token }
        set(gitlab: gitlab)
      end

      def set_alias(email, alias)
        aliases = get[:aliases] || {}
        aliases[alias.to_sym] = email
        configuration.set(aliases: aliases)
      end

      def delete_alias

      end

      def set_users
      end

      def clear_users

      end

      private

      def display_conf(conf=configuration.get)
        ap conf || "No configuration yet"
      end

      def get_configuration_key(params)
        conf = configuration.get
        params.compact.each do |key|
          conf = conf[key.to_sym] || {}
        end
        conf
      end

      def configuration
        @configuration ||= Configuration.new
      end
    end
  end
end