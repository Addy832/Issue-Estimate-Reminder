require 'sinatra'
require 'json'
require 'dotenv/load'
require_relative 'config/initializers'
require_relative 'services/github_client_service'
require_relative 'services/webhook_verification_service'

class GitHubApp
  def initialize(request)
    @request = request
    @github_client = GitHubClientService.new
  end

  def handle_webhook(payload_body)
    WebhookVerificationService.new(@request).verify_signature(payload_body)
    event = JSON.parse(payload_body)

    if valid_issue_event?(event)
      issue = event['issue']
      repository = event['repository']

      unless estimate_present?(issue['body'])
        @github_client.add_estimate_comment(repository['full_name'], issue['number'])
      end
    else
      raise "No valid issue event detected."
    end
  end

  private

  def valid_issue_event?(event)
    event['action'] == 'opened' && event['issue']
  end

  def estimate_present?(issue_body)
    issue_body&.match(/Estimate: \d+ days/)
  end
end

class MyApp < Sinatra::Base
  post '/payload' do
    request.body.rewind
    payload_body = request.body.read
    github_app = GitHubApp.new(request)
    begin
      github_app.handle_webhook(payload_body)
      status 200
    rescue => e
      status 400
      body e.message
    end
  end
end

MyApp.run! if __FILE__ == $0
