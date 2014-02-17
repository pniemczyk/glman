# Glman

GitLab bash manager

## Installation

    $ gem install glman

## Usage

### Configuration

setup

    $ glman config <gitlab_url> <private_token> --init

show

    $ glman config

### Aliases

create 

    $ glman alias <user_email> <alias>

clear all aliases

    $ glman alias --clear

### User cache

build cache

    $ glman cache

clear cache

    $ glman cache --clear

### Merge requests

make default: (make merge request from current branch to master with last commit message)

    $ glman mr <user_email_or_alias>

make with git push <origin> current_branch

    $ glman mr <user_email_or_alias> --push <origin(default 'origin')>

make full syntax

    $ glman mr <user_email_or_alias> <message> <target_branch>

show merge requests

    $ glman mr --show


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
