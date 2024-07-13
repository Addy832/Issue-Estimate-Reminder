# spec/github_app_spec.rb

require 'spec_helper'

RSpec.describe GitHubApp do
  let(:request) { double('request', env: { 'HTTP_X_HUB_SIGNATURE' => 'sha1=signature' }) }
  let(:github_app) { GitHubApp.new(request) }
  let(:payload_body) { '{"action": "opened", "issue": {"body": "Some issue body"}, "repository": {"full_name": "test/repo"}}' }

  describe '#handle_webhook' do
    before do
      allow_any_instance_of(WebhookVerificationService).to receive(:verify_signature).and_return(true)
      allow_any_instance_of(GitHubClientService).to receive(:add_estimate_comment).and_return(true)
    end

    it 'handles a valid issue event' do
      expect { github_app.handle_webhook(payload_body) }.not_to raise_error
    end

    it 'raises an error for an invalid issue event' do
      invalid_payload = '{"action": "closed", "issue": {"body": "Some issue body"}}'
      expect { github_app.handle_webhook(invalid_payload) }.to raise_error(RuntimeError, 'No valid issue event detected.')
    end

    it 'adds a comment if the estimate is missing' do
      allow(github_app).to receive(:estimate_present?).and_return(false)
      expect_any_instance_of(GitHubClientService).to receive(:add_estimate_comment)
      github_app.handle_webhook(payload_body)
    end

    it 'does not add a comment if the estimate is present' do
      payload_with_estimate = '{"action": "opened", "issue": {"body": "Estimate: 2 days"}, "repository": {"full_name": "test/repo"}}'
      expect_any_instance_of(GitHubClientService).not_to receive(:add_estimate_comment)
      github_app.handle_webhook(payload_with_estimate)
    end
  end
end
