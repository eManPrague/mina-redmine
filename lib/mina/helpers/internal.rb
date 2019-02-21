module Mina
  module Helpers
    module Internal
      include Helpers::Output

      def redmine_deploy_message
        {
          project: fetch(:redmine_project),
          server: fetch(:redmine_server),
          changes: fetch(:redmine_changes),
          revision: short_revision
        }
      end

      def send_redmine_message(message, redmine_url, redmine_project, redmine_token)
        uri = URI.parse("#{redmine_url}/deploy_webhook")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/json'
        request['X-Deploy-Token'] = redmine_token
        request['Accept'] = 'application/json'
        request.set_form_data(payload: message.to_json)

        http.request(request)
      rescue Encoding::InvalidByteSequenceError
        comment 'Invalid byte sequence'
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
    end
  end
end

extend Mina::Helpers::Internal
