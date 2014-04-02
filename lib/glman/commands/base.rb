require "glman/version"
require 'executable'
require 'awesome_print'
require "irc-notify"

module Glman
  module Commands
    class Base
      include Executable

      # merge_request  user_name/email message target_branch
      def mr(params)
        return ap mr_command.get_all if show?
        user_name      = params[0]
        user_id        = get_user_id(user_name)
        target_branch  = params[2] || 'master'
        current_branch = git_repo.current_branch
        msg            = params[1] || git_repo.last_commit_message || current_branch

        push_branch_first(origin, current_branch) unless origin.nil?

        ap mr_command.create(user_id: user_id, msg: msg, target_branch: target_branch)
      rescue IncorrectMrOptionsError => e
        p e.message
      end

      def push=(origin=nil)
        @origin = origin || 'origin'
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
          params.empty? ? configuration.show_aliases : configuration.add_user_alias(email: params[0], alias: params[1])
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
      def help!
        puts 'Need help :D'
        puts help_page
        exit
      end
      alias :h! :help!

      #Exec
      def call(name=nil, *params)
        intro
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
        p "push branch: #{branch} to origin: origin"
        git_repo.push('origin', branch)
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

      def mr_command
        @mr_command ||= Mr.new(git_repo: git_repo, projects_repo: projects_repo, config: configuration.load)
      end

      def notify(msg)
        nick = configuration.load[:irc][:nick] || "glman-#{git_repo.user_name.strip.downcase.gsub(' ','-')}"
        irc_client.register(nick)
        irc_client.notify(configuration.load[:irc][:channel], msg)
        client.quit
      end

      def irc_client
        @irc_client ||= (
          irc_config = configuration.load[:irc]
          server = irc_config[:server] || "irc.freenode.net"
          port   = (irc_config[:port] || 6697).to_i
          ssl    = irc_config[:ssl] == true ? true : false
          IrcNotify::Client.build(server, port, ssl: ssl)
        )
      end

      def help_page
        %{
commands:

config                                         # display current configuration
config <gitlab_url> <private_token> --init     # init configuration
notify_config <server:port> <channel> <is_ssl> # setup irc configuration for notifications

alias                                          # display aliases
alias <user_email> <alias>                     # make alias for user email
alias --clear                                  # clear all aliases

cache                                          # build user cache for better performance RECOMMENDED
cache --clear                                  # clear user cache

mr <user_email_or_alias>                       # create merge request for user for current branch to master with title as last commit message

mr <user_email_or_alias> <message> <target_branch> --push <origin> # full options for merge request (default origin is a origin :D)

Any questions pniemczyk@o2.pl or go to https://github.com/pniemczyk/glman
        }
      end

      def intro
        puts "Glman ver: #{VERSION}"
      end
    end
  end
end