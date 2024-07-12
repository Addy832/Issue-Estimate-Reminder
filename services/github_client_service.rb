require 'octokit'
require 'openssl'
require 'jwt'

class GitHubClientService
  def initialize
    @client = initialize_octokit_client
    @installation_id = fetch_installation_id
    @installation_token = fetch_installation_token
    @client = Octokit::Client.new(access_token: @installation_token)
  end

  def add_estimate_comment(repository_full_name, issue_number)
    @client.add_comment(repository_full_name, issue_number, "Please provide an estimate in the format 'Estimate: X days'.")
  rescue Octokit::NotFound
    raise "Error: Issue or repository not found."
  rescue Octokit::Unauthorized
    raise "Error: Unauthorized access. Please check your access token and permissions."
  rescue StandardError => e
    raise "An error occurred: #{e.message}"
  end

  private

  def initialize_octokit_client
    private_pem = File.read('config/issue-estimate-reminder.2024-07-12.private-key.pem')
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
      iat: Time.now.to_i,
      exp: Time.now.to_i + (10 * 60), # 10 minutes expiry
      iss: ENV['GITHUB_APP_ID']
    }

    jwt = JWT.encode(payload, private_key, 'RS256')
    Octokit::Client.new(bearer_token: jwt)
  end

  def fetch_installation_id
    installations = @client.find_app_installations
    raise "No installations found for the GitHub App. Please make sure the app is installed in your repository." if installations.empty?

    installations.first[:id]
  end

  def fetch_installation_token
    @client.create_app_installation_access_token(@installation_id)[:token]
  end
end
