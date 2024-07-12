require 'openssl'
require 'rack/utils'

class WebhookVerificationService
  def initialize(request)
    @request = request
  end

  def verify_signature(payload_body)
    secret = ENV['WEBHOOK_SECRET']
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload_body)
    raise "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, @request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
