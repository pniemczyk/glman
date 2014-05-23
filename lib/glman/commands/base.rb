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
        return dp mr_command.get_all if params.length == 0
        user_name      = params[0]
        user_id        = get_user_id(user_name)
        target_branch  = params[2] || 'master'
        current_branch = git_repo.current_branch
        msg            = params[1] || git_repo.last_commit_message || current_branch

        push_branch_first(origin, current_branch) unless origin.nil?

        result = mr_command.create(user_id: user_id, msg: msg, target_branch: target_branch)
        dp result
        irc_notify("Please review my merge request: #{result[:diff_url]}") if notify?
      rescue Exception => e
        dp e.message
      end

      def push=(origin=nil)
        @origin = origin || 'origin'
      end

      def get_user_id(name)
        user  = nil
        email = (configuration.get(:aliases) || {})[name]
        user  = (configuration.get(:users)   || {})[email] if email
        user  = users_repo.find(email: name) unless user
        user[:id] if user
      end

      # Make Cache for user
      def users_cache
        return configuration.clear(:users) if clear?

        users = {}.tap do |h|
          users_repo.list.each{ |u| h[u['email']] = u }
        end

        configuration.set(:users, users)
      end

      # Set/Get configuration
      def config(params=[])
        return configuration.show(params) unless [set?, del?, add?, clear?].any?
        key  = params.shift.to_sym

        configuration.delete(key, params[0]) if del?
        configuration.clear(key)             if clear?

        if set? || add?
          opts = build_configuration_params(params)
          configuration.set(key, opts) if set?
          configuration.add(key, opts) if add?
        end

        #TODO later
        key = ['notify', 'irc'] if key == :notify_irc

        configuration.show(key)
      end

      #flags
      def s=(bool); @set = bool; end
      def set=(bool); @set = bool; end
      def set?; @set; end

      def a=(bool); @add = bool; end
      def add=(bool); @add = bool; end
      def add?; @add; end

      def d=(bool); @del = bool; end
      def del=(bool); @del = bool; end
      def del?; @del; end

      def c=(bool); @clear = bool; end
      def clear=(bool); @clear = bool; end
      def clear?; @clear; end

      def n=(bool); @notify = bool; end
      def notify=(bool); @notify = bool; end
      def notify?; @notify; end

      def help!
        puts Glman::Commands::HelpMessages.show
        exit
      end
      alias :h! :help!

      #Exec
      def call(name=nil, *params)
        puts Glman::Commands::HelpMessages.intro
        case name.to_s.strip
          when 'config'      then config(params)
          when 'alias'       then user_alias(params)
          when 'users_cache' then users_cache
          when 'mr'          then mr(params)
          when ''            then puts Glman::Commands::HelpMessages.unknown_command
          else puts "what ?"
        end
      end

      private

      attr_reader :origin

      def build_configuration_params(params)
        Hash.new.tap do |h|
          params.each{ |e| e = e.split(':'); h[e.shift.to_sym] = e.join(':') }
        end
      end

      def push_branch_first(origin, branch)
        p "push branch: #{branch} to origin: origin"
        git_repo.push('origin', branch)
      end

      def show_all_mrs
        ap projects_repo.get_merge_requests(git_repo.repository_name)
      end

      def configuration
        @configuration ||= Glman::Commands::Config.new(config_manager: ConfigManager.new)
      end

      def users_repo
        @users_repo ||= Repos::UsersRepo.new(configuration.get(:gitlab))
      end

      def projects_repo
        @projects_repo ||= Repos::ProjectsRepo.new(configuration.get(:gitlab))
      end

      def git_repo
        @git_repo ||= Repos::GitRepo.new
      end

      def mr_command
        @mr_command ||= Glman::Commands::Mr.new(git_repo: git_repo, projects_repo: projects_repo, config: configuration.get(:gitlab))
      end


      def irc_conf
        @irc_conf ||= configuration.get(:notify_irc)
      end

      def irc_notify(msg)
        c       = IrcNotify::Client.build(irc_conf[:server], irc_conf[:port], ssl: irc_conf[:ssl])
        nick    = irc_conf[:nick] || "glman-#{git_repo.user_name.strip.downcase.gsub(' ','-')}"
        channel = '#' + irc_conf[:channel].gsub('#', '')
        c.register(nick)
        c.notify(channel, msg)
        c.quit
      end
    end
  end
end