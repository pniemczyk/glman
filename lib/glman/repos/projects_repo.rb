require 'httpclient'
require 'uri'
require 'cgi'
require 'json'

module Glman
  module Repos
    class ProjectsRepo
      PER_PAGE = 10000
      def initialize(opts={})
        @gitlab_url    = opts.fetch(:url)
        @private_token = opts.fetch(:private_token)
      end
      def list
        all
      end

      def get(id)
        get_base(id)
      end

      def get_events(id)
        get_base(id, 'events')
      end

      def get_team_members(id, member_id=nil)
        path = ['members', member_id].compact.join('/')
        get_base(id, path)
      end

      def get_hooks(id, hook_id=nil)
        path = ['hooks', hook_id].compact.join('/')
        get_base(id, path)
      end

      def get_branches(id, branch_id=nil)
        path = ['repository/branches', branch_id].compact.join('/')
        get_base(id, path)
      end

      def get_merge_requests(id, mk_id=nil)
        path = ['merge_requests', mk_id].compact.join('/')
        get_base(id, path)
      end

      def create_merge_request(id, opts={})
        merge_request_params_validate(opts)
        #source_branch, target_branch, assignee_id, title
        JSON.parse(client.post(url(id: id, path: 'merge_requests'), opts).body)
      end

      def find(opts={})
        opts = Hash[opts.map{ |k, v| [k.to_s, v] }]
        all.each do |project|
          return project if project.eql?(project.merge(opts))
        end
        nil
      end

      private
      attr_reader :gitlab_url, :private_token

      def merge_request_params_validate(params)
        raise ArgumentError, 'source_branch missing in configuration' unless params.has_key?(:source_branch)
        raise ArgumentError, 'target_branch missing in configuration' unless params.has_key?(:target_branch)
        raise ArgumentError, 'title missing in configuration'         unless params.has_key?(:title)
      end

      def get_base(id, path=nil)
        JSON.parse(client.get(url(id: id, path: path)).body)
      end

      def all
        JSON.parse(client.get(url).body)
      end

      def url(opts={})
        id   = CGI.escape(opts[:id].to_s) if opts[:id]
        path = opts[:path]
        uri  = [gitlab_url, 'api', 'v3', 'projects', id, path, "?private_token=#{private_token}&per_page=#{PER_PAGE}"].compact.join('/')
        URI.join(uri)
      end

      def client
        @client ||= HTTPClient.new
      end
    end
  end
end


# USAGE


# glman mk rafal.klimek "to co" source_branch target_branch

# glman mr rafal

# glman setconfig gl_url token

# glman cache users

# glman user alias rafal rafal.klimek


# TODO

