module Glman
  module Commands
    module Configs
      class UsersConfig
        class UsersConfigurationError < StandardError; end

        include InitRequired

        attr_required :config_manager

        DEFAULT = {}

        def set(users={})
          raise UsersConfigurationError.new('incorrect data') unless users.kind_of? Hash
          hash = nil if hash.empty?
          config_manager.set(users: users)
        end

        def get
          config_manager.get[:users] || DEFAULT
        end

        def clear
          set(DEFAULT)
        end
      end
    end
  end
end
