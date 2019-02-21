# Required
set :redmine_url, -> { ENV['REDMINE_URL'] }
set :redmine_room, -> { ENV['REDMINE_ROOM'] }
set :redmine_token, -> { ENV['REDMINE_TOKEN'] }

# Git
set :deployer,          -> { ENV['GIT_AUTHOR_NAME'] || %x[git config user.name].chomp }
