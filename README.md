# Mina::Redmine

Announce Mina deployments to redmine - add info to your tickets where
have been deployed and move them in proper state.

## Installation

Add this line to your application's Gemfile:

    gem 'mina-redmine', github: "eManPrague/mina-redmine"

And then execute:

    $ bundle

## Usage

### Load the recipe
Include the recipe in your deploy.rb

    # config/deploy.rb
    require 'mina/redmine'

### Setup Mina redmine
You'll need to setup your redmine details with an API key, room and subdomain. You can add these as ENV variables or in the config/deploy.rb

    # required
    set :redmine_url, 'https://redmine.org/' # Redmine url
    set :redmine_project, 'my_cool_project' # Project name
    set :redmine_token, 'ABCD1234' # Your deployer profile token

Or use the ENV variables:

    # required
    ENV['redmine_url'] = ''
    ENV['redmine_project'] = ''
    ENV['redmine_token'] = ''


 Update `deploy` task to invoke `redmine:post_info` task:

 ```ruby
task :deploy do
  invoke :'redmine:post_info'
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/mina-redmine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
