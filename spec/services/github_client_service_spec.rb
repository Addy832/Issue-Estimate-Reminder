# spec/services/github_client_service_spec.rb

require 'spec_helper'

RSpec.describe GitHubClientService do
  let(:client_service) { GitHubClientService.new }
  let(:repository_full_name) { 'test/repo' }
  let(:issue_number) { 1 }

  describe '#add_estimate_comment' do
    it 'adds a comment to the issue' do
      allow_any_instance_of(Octokit::Client).to receive(:add_comment).and_return(true)
      expect { client_service.add_estimate_comment(repository_full_name, issue_number) }.not_to raise_error
    end

    it 'raises an error if the issue or repository is not found' do
      allow_any_instance_of(Octokit::Client).to receive(:add_comment).and_raise(Octokit::NotFound)
      expect { client_service.add_estimate_comment(repository_full_name, issue_number) }.to raise_error(RuntimeError, 'Error: Issue or repository not found.')
    end

    it 'raises an error if unauthorized access' do
      allow_any_instance_of(Octokit::Client).to receive(:add_comment).and_raise(Octokit::Unauthorized)
      expect { client_service.add_estimate_comment(repository_full_name, issue_number) }.to raise_error(RuntimeError, 'Error: Unauthorized access. Please check your access token and permissions.')
    end
  end
end
