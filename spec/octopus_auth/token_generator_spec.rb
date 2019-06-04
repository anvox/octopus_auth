require 'spec_helper'

RSpec.describe OctopusAuth::TokenGenerator do
  before do
    OctopusAuth.configure do |config|
      config.model_class = MockAccessToken
      config.token_length = 20
    end

    allow(MockAccessToken).to receive(:where).with(anything).and_return(MockAccessToken)
  end

  context 'token doesnt exist' do
    before do
      allow(MockAccessToken).to receive(:exists?).and_return(false)
    end

    it 'return token' do
      expect(SecureRandom).to receive(:hex).with(10).once.and_call_original
      expect(OctopusAuth::TokenGenerator.unique_token).to be
    end
  end

  context 'token exists once' do
    before do
      allow(MockAccessToken).to receive(:exists?).and_return(true, false)
    end

    it 'return token' do
      expect(SecureRandom).to receive(:hex).with(10).twice.and_call_original
      expect(OctopusAuth::TokenGenerator.unique_token).to be
    end
  end
end
