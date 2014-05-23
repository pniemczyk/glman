module Glman
  module Commands
    module Configs
      class NotifyIrcConfig
        class NotifyIrcConfigurationError < StandardError; end

        include InitRequired

        attr_required :config_manager

        DEFAULT = {
          nick:    'glman',
          channel: 'glman_notify',
          server:  'irc.freenode.net',
          port:    6697,
          ssl:     true
        }

        def set(opts={})
          raise NotifyIrcConfigurationError.new('incorrect data') unless opts.kind_of? Hash
          notify = config_manager.get[:notify] || {}
          irc    = notify[:irc] || {}

          irc[:server]  = opts[:server]  || irc[:server]  || DEFAULT[:server]
          irc[:nick]    = opts[:nick]    || irc[:nick]    || DEFAULT[:nick]
          irc[:port]    = (opts[:port]   || irc[:port]    || DEFAULT[:port]).to_i
          irc[:channel] = opts[:channel] || irc[:channel] || DEFAULT[:channel]
          irc[:ssl]     = if opts[:ssl].nil?
            irc[:ssl].nil? ? true : irc[:ssl]
          else
            opts[:ssl].to_s == 'true'
          end

          notify[:irc] = irc
          config_manager.set(notify: notify)
        end

        def get
          (config_manager.get[:notify] || {})[:irc] || DEFAULT
        end

        def clear
          set(DEFAULT)
        end
      end
    end
  end
end
