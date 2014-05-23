require "irc-notify"

module Glman
  module Commands
    class Notify
      attr_reader :config, :irc_config, :irc_client, :nick, :server, :port, :ssl

      def initialize(opts={})
        @config = opts.fetch(:config)
      end

      def send(msg)
        irc_client.register(nick)
        irc_client.notify(channel, msg)
        client.quit
      end

      def nick
        @nick ||= irc_config.fetch(:nick)
      end

      def channel
        @channel ||= irc_config.fetch(:channel)
      end

      def server
        @server ||= irc_config.fetch(:server)
      end

      def port
        @port ||= irc_config.fetch(:port)
      end

      def ssl
        @ssl ||= irc_config.fetch(:ssl)
      end

      def irc_config
        @irc_config ||= config.fetch(:notify_cfg).fetch(:irc)
      end

      def irc_client
        @irc_client ||= IrcNotify::Client.build(server, port, ssl: ssl)
      end

    end
  end
end