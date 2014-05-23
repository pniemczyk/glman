module Glman
  module Commands
    class Mr
      class IncorrectMrOptionsError < StandardError; end
      attr_reader :projects_repo, :git_repo, :config

      def initialize(opts={})
        @git_repo      = opts.fetch(:git_repo)
        @config        = opts.fetch(:config)
        @projects_repo = opts.fetch(:projects_repo)
      end

      def create(params={})
        user_id, msg, target_branch = params[:user_id], params[:msg], params.fetch(:target_branch, 'master')
        raise IncorrectMrOptionsError.new('Merge request branch target and source are the same.') if target_branch == current_branch
        mr_opts = {assignee_id: user_id, title: msg, source_branch: current_branch, target_branch: target_branch}
        prepare_details(create_merge_request(mr_opts))
      end

      def get_all
        projects_repo.get_merge_requests(git_repo.repository_name)
      end

      private

      def create_merge_request(opts)
        projects_repo.create_merge_request(repository_name, opts)
      end

      def repository_name
        @repository_name ||= git_repo.repository_name
      end

      def current_branch
        @current_branch ||= git_repo.current_branch
      end

      def gitlab_url
        @gitlab_url ||= config[:url]
      end

      def prepare_details(create_result)
        assignee  = create_result.fetch('assignee', {}) || {}
        author    = create_result.fetch('author', {})   || {}
        url       = "#{gitlab_url}/#{repository_name}/merge_requests/#{create_result['iid']}"
        {
          repository_name: repository_name,
          current_branch:  current_branch,
          target_branch:   create_result['target_branch'],
          message:         create_result['title'],
          url:             url,
          diff_url:        "#{url}/diffs",
          assignee: {
            username: assignee['username'],
            email:    assignee['email'],
            name:     assignee['name']
          },
          author: {
            username: author['username'],
            email:    author['email'],
            name:     author['name']
          },
          id:         create_result['id'],
          iid:        create_result['iid'],
          created_at: assignee['created_at']
        }
      end
    end
  end
end