require "glman/version"
require 'executable'
require 'awesome_print'

module Glman
  module Commands
    class Base
      include Executable

      # merge_request  user_name/email message target_branch
      def mr(params)
        return show_all_mrs if show?
        user_name       = params[0]
        current_branch  = git_repo.current_branch
        p 'You realy want to create merge request master to master ?' if current_branch == 'master'
        target_branch   = params[2] || 'master'
        user_id         = get_user_id(user_name)
        message         = params[1] || git_repo.last_commit_message || current_branch
        repository_name = git_repo.repository_name

        params = {assignee_id: user_id, title: message, source_branch: current_branch, target_branch: target_branch}

        push_branch_first(push, current_branch) if push?

        projects_repo.create_merge_request(repository_name, params)
        ap params.merge({user_name: user_name, repository_name: repository_name})
      end

      def push=(origin=nil)
        @origin = origin || 'origin'
      end

      def push?
        @origin
      end

      def show=(bool)
        @show = bool
      end

      def show?
        @show
      end

      def get_user_id(name)
        user  = nil
        email = (configuration.load[:aliases] || {})[name]
        user  = (configuration.load[:users] || {})[email] if email
        user  = users_repo.find(email: name) unless user
        user[:id] if user
      end

      # Set/Get configuration
      def config(params=[])
        build_config(*params) if init?
        ap configuration.load || "No configuration yet"
      end

      # Set user alias
      def user_alias(params)
        if clear?
          configuration.clear_user_aliases
        else
          configuration.add_user_alias(email: params[0], alias: params[1])
        end
        config
      end

      # Make Cache for user
      def cache
        if clear?
          configuration.set_user_list({})
        else
          users = {}.tap do |h|
            users_repo.list.each{ |u| h[u['email']] = u }
          end
          configuration.set_user_list(users)
        end
        config
      end

      def clear=(bool)
        @clear = bool
      end

      def clear?
        @clear
      end


      #initialize configutation  | cmd  glman config [gitlab_url] [private_token] --init
      def init=(bool)
        @init = bool
      end

      #
      def init?
        @init
      end

      # Show help
      def help?
        puts 'help me :D'
        exit
      end
      alias :h? :help?

      #Exec
      def call(name=nil, *params)
        case name.to_s.strip
          when 'config' then config(params)
          when 'alias'  then user_alias(params)
          when 'cache'  then cache
          when 'mr'     then mr(params)
          when ''       then puts '-'
          else puts "what ?"
        end
      end
      private

      attr_reader :origin

      def push_branch_first(origin, branch)
        p "push branch: #{branch} to origin: #{origin}"
        git_repo.push(origin, branch)
      end

      def show_all_mrs
        ap projects_repo.get_merge_requests(git_repo.repository_name)
      end

      def build_config(gitlab_url, private_token)
        configuration.build_config(gitlab_url: gitlab_url, private_token: private_token)
      end

      def configuration
        @configuration ||= Configuration.new
      end

      def users_repo
        @users_repo ||= Repos::UsersRepo.new(configuration.load)
      end

      def projects_repo
        @projects_repo ||= Repos::ProjectsRepo.new(configuration.load)
      end

      def git_repo
        @git_repo ||= Repos::GitRepo.new
      end
    end
  end
end