module Glman
  module Commands
    module Configs
      class AliasesConfig
        class AliasesConfigurationError < StandardError; end

        include InitRequired

        attr_required :config_manager

        DEFAULT = {}

        def add(hash={})
          email       = hash[:email]
          alias_name  = hash[:alias_name]
          hash = alias_name.nil? ? symbolize_keys(hash) : { alias_name.to_sym => email }
          aliases = get
          aliases = aliases.merge(hash)
          set(aliases)
        end

        def delete(alias_name)
          aliases = config_manager.get[:aliases] || {}
          aliases.delete_if{ |k, _| k==alias_name.to_s }
          set(aliases)
        end

        def set(hash={})
          raise AliasesConfigurationError.new('incorrect aliases data') unless hash.kind_of? Hash
          hash = nil if hash.empty?
          config_manager.set(aliases: hash)
        end

        def get
          (config_manager.get || {})[:aliases] || DEFAULT
        end

        def clear
          set(DEFAULT)
        end

        private

        def symbolize_keys(hash)
          hash.inject({}) do |result, (key, value)|
            result[key.to_sym] = value
            result
          end
        end
      end
    end
  end
end
