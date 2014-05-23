module Glman
  module Commands
    class HelpMessages
      def self.intro
        "Glman ver: #{VERSION}"
      end

      def self.unknown_command
        "Command unknown"
      end

      def self.show
        %{
Need help :D

commands:

config                                         # display current configuration
config gitlab                                  # show gitlab configuration
config users                                   # show users configuration
config aliases                                 # show aliases configuration
config notify_irc                              # show notify_irc configuration

you can show specific config details:

  config gitlab url                    # specific attribute in gitlab config
  config users pniemczyk@o2 id         # specific attribute in users config

config gitlab url:http://site private_token:123 --set
config gitlab --clear

config notify_irc server:irc.org channel:free ssl:true port:10 nick:test --set
config notify_irc --clear

config aliases pn:pawel@o2.pl --add
config aliases pn --del
config aliases --clear

cache_users                                    # build user cache for better performance RECOMMENDED
cache_users --clear                            # clear user cache

mr <user_email_or_alias>                       # create merge request for user for current branch to master with title as last commit message

mr <user_email_or_alias> --push                # push before make a merge request
mr <user_email_or_alias> --notify              # notify on irc after merge request

mr <user_email_or_alias> --push --notify       # :D

mr <user_email_or_alias> <message> <target_branch> --push <origin> # full options for merge request (default origin is a origin :D)

Any questions pniemczyk@o2.pl or go to https://github.com/pniemczyk/glman
        }
      end
    end
  end
end
