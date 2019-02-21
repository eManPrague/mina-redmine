# Redmine tasks
namespace :redmine do
  task :post_info do
    if (url = fetch(:redmine_url)) && (project = fetch(:redmine_project) && (token = fetch(:redmine_token))
      login_data = if (user = fetch(:user))
        [ fetch(:domain), user ]
      else
        # "bob@127.5.1.2".split('@')
        fetch(:domain).split('@').reverse
      end

      Net::SSH.start(login_data[0], login_data[1]) do |ssh|
        set(:last_revision, ssh.exec!("cd #{fetch(:deploy_to)}/scm; git log -n 1 --pretty=format:'%H' #{fetch(:branch)} --"))
      end

      set(:last_commit, `git log -n 1 --pretty=format:"%H" origin/#{fetch(:branch)} --`)
      changes
      send_redmine_message(redmine_deploy_messagem, url, project, token)
    else
      print_status 'Unable to create Redmine Announcement, no redmine details provided.'
    end
  end
end
