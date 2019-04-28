require 'byebug'

# Redmine tasks
namespace :redmine do
  def short_revision
    deployed_revision = fetch(:last_commit)
    deployed_revision[0..8] if deployed_revision
  end

  def redmine_deploy_message
    {
      project: fetch(:redmine_project),
      server: fetch(:redmine_server),
      changes: fetch(:redmine_changes),
      revision: short_revision
    }
  end

  def send_redmine_message(message, redmine_url, redmine_project, redmine_token)
    comment %{Sending redmine deploy info}
    command %{
      curl -X POST #{redmine_url}/deploy_webhook \
        -H "Content-Type: application/json" \
        -H "X-Deploy-Token: #{redmine_token}" \
        -d '#{message.to_json}'
    }
  end

  def redmine_changes
    last_revision = fetch(:last_revision)
    query = if last_revision.empty?
              "#{fetch(:deployed_revision)} origin/#{fetch(:branch)}"
            else
              "#{fetch(:last_revision)}...#{fetch(:last_commit)} origin/#{fetch(:branch)}"
            end

    data = (`git --no-pager log --pretty=format:'%s%nMESSAGE_SEPARATOR%n%H%nCOMMIT_SEPARATOR%n' --date=short --abbrev-commit #{query} --`)
      .split("\nCOMMIT_SEPARATOR\n")
      .map { |m|
      message, commit = m.strip.split("\nMESSAGE_SEPARATOR\n")
      {
        message: message.strip,
        commit: commit.strip
      }
    }

    set(:redmine_changes, data)
  end

  task :post_info do
    if (url = fetch(:redmine_url)) && (project = fetch(:redmine_project)) && (token = fetch(:redmine_token))
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
      redmine_changes
      send_redmine_message(redmine_deploy_message, url, project, token)
    else
      print_status 'Unable to create Redmine Announcement, no redmine details provided (:redmine_url, :redmine_project, :redmine_token).'
    end
  end
end
