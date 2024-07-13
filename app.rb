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

class MyApp < Sinatra::Base
  post '/payload' do
    request.body.rewind
    payload_body = request.body.read
    github_app = GitHubApp.new(request)
  end
end

MyApp.run!
