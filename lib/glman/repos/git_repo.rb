module Glman
  module Repos
    class GitRepo
      def remote_origin_ssh_url
        %x[git remote -v].split("\t").select{ |c| c.include?('(push)')}.first.gsub('(push)', '').gsub("\n", '').strip
      rescue
        nil
      end

      def repository_name
        remote_origin_ssh_url.split(':').last.gsub('.git','')
      rescue
        nil
      end

      def current_branch
        %x[git br].split("\n").select{ |c| c.include?('*')}.first.gsub('*','').strip
      rescue
        nil
      end

      def last_commit_message
        %x[git log -1].split("\n").select{|c| c.include?('Subject:')}.first.gsub('Subject:','').strip
      rescue
        nil
      end

      def user_name
        %x[git config user.name]
      end

      def user_email
        %x[git config user.email]
      end

      def push(origin, branch)
        cmd = "git push #{origin} #{branch}"
        %x[#{cmd}]
      rescue
        nil
      end
    end
  end
end