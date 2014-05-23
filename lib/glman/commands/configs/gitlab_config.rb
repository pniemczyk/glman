require 'uri'

module Glman
  module Commands
    module Configs
      class GitlabConfig
        class GitlabConfigurationError < StandardError; end

        include InitRequired

        attr_required :config_manager

        DEFAULT = { url: '', private_token: '' }

        def set(hash={})
          raise GitlabConfigurationError.new('incorrect data') unless hash.kind_of? Hash
          raise GitlabConfigurationError.new "url is incorrect" unless valid_url?(hash[:url])
          raise GitlabConfigurationError.new "private_token missing" if hash[:private_token].to_s.strip.empty?

          gitlab = {url: hash[:url], private_token:  hash[:private_token]}

          config_manager.set(gitlab: gitlab)
        end

        def get
          (config_manager.get || {})[:gitlab] || DEFAULT
        end

        def clear
          config_manager.set(gitlab: DEFAULT)
        end

        private

        def valid_url?(url)
          url = URI.parse(url) rescue false
          url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
        end
      end
    end
  end
end
