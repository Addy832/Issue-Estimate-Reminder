# spec/services/webhook_verification_service_spec.rb

require 'spec_helper'

RSpec.describe WebhookVerificationService do
  let(:request) { double('request', env: { 'HTTP_X_HUB_SIGNATURE' => 'sha1=signature' }) }
  let(:payload_body) { 'payload' }
  let(:verification_service) { WebhookVerificationService.new(request) }

  describe '#verify_signature' do
    it 'verifies the signature' do
      allow(OpenSSL::HMAC).to receive(:hexdigest).and_return('signature')
      expect { verification_service.verify_signature(payload_body) }.not_to raise_error
    end

    it 'raises an error if the signature does not match' do
      allow(OpenSSL::HMAC).to receive(:hexdigest).and_return('wrong_signature')
      expect { verification_service.verify_signature(payload_body) }.to raise_error(RuntimeError, "Signatures didn't match!")
    end
  end
end
