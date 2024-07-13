# spec/spec_helper.rb

require 'rack/test'
require 'rspec'
require 'dotenv/load'
require_relative '../app'
require_relative '../services/github_client_service'
require_relative '../services/webhook_verification_service'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() MyApp end
end

RSpec.configure do |config|
  config.include RSpecMixin
end
