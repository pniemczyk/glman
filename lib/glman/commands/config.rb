require "irc-notify"

module Glman
  module Commands
    class Config

      include InitRequired

      attr_required :config_manager

      def show(params=[])
        get_configuration_by_key(params).tap do |conf|
          dp conf.blank? ? "No configuration yet" : conf
        end
      end

      def set(name, hash={})
        send("#{name}_conf").set(hash)
      end

      def get(name)
        send("#{name}_conf").get
      end

      def clear(name)
        send("#{name}_conf").clear
      end

      def add(name, params)
        send("#{name}_conf").add(params)
      end

      def delete(name, params)
        send("#{name}_conf").delete(params)
      end

      private

      def get_configuration_by_key(params)
        return config_manager.get if params.blank?
        return config_manager.get[params.to_sym] unless params.kind_of?(Array)

        conf = config_manager.get
        params.compact.each{ |key| conf = conf[key.to_sym] || {} }
        conf
      end

      def users_conf
        @users_conf ||= Glman::Commands::Configs::UsersConfig.new(config_manager: config_manager)
      end

      def notify_irc_conf
        @notify_irc_conf ||= Glman::Commands::Configs::NotifyIrcConfig.new(config_manager: config_manager)
      end

      def gitlab_conf
        @gitlab_conf ||= Glman::Commands::Configs::GitlabConfig.new(config_manager: config_manager)
      end

      def aliases_conf
        @aliases_conf ||= Glman::Commands::Configs::AliasesConfig.new(config_manager: config_manager)
      end
    end
  end
end