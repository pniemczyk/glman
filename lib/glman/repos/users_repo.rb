require 'httpclient'
require 'uri'
require 'json'

module Glman
  module Repos
    class UsersRepo
      PER_PAGE = 10000
      def initialize(opts={})
        @gitlab_url    = opts.fetch(:gitlab_url)
        @private_token = opts.fetch(:private_token)
      end
      def list
        all
      end

      def get(id)
        JSON.parse(client.get(url(id)).body)
      end

      def find(opts={})
        opts = Hash[opts.map{ |k, v| [k.to_s, v] }]
        all.each do |user|
          return user if user.eql?(user.merge(opts))
        end
        nil
      end

      private
      attr_reader :gitlab_url, :private_token

      def all
        JSON.parse(client.get(url).body)
      end

      def url(id=nil)
        url = [gitlab_url, 'api', 'v3', 'users', id, "?private_token=#{private_token}&per_page=#{PER_PAGE}"].compact.join('/')
        URI.join(url)
      end

      def client
        @client ||= HTTPClient.new
      end
    end
  end
end