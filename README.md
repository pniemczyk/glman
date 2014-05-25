# Glman

GitLab bash manager

## *Warning* please remove ~/.glmanrc file after upgrade from ~0.0.x version

## Installation

    $ gem install glman

## Usage

### Configuration

setup

    $ glman config gitlab url:http://site private_token:123 --set

show

    $ glman config

### Aliases

add

    $ glman config aliases pn:pawel@o2.pl --add

delete

    $ glman config aliases pn --del

clear all aliases

    $ glman config aliases --clear

### User cache

build cache

    $ glman cache_users

clear cache

    $ glman cache_users --clear

### Merge requests

make default: (make merge request from current branch to master with last commit message)

    $ glman mr <user_email_or_alias>

make with git push <origin> current_branch

    $ glman mr <user_email_or_alias> --push <origin (default 'origin')>

make full syntax

    $ glman mr <user_email_or_alias> <message> <target_branch>

make optional options (push repo, create mr and notify on irc)

    $ glman mr <user_email_or_alias> --push --notify

show merge requests

    $ glman mr


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
