require 'spec_helper'

RSpec.describe OctopusAuth::Revoke do
  before do
    OctopusAuth.configure do |config|
      config.model_class = MockAccessToken
      config.token_life_time = 1.*60*60 # 1 hour
      config.scopes = [:organization, :user]
      config.default_scope = :user
      config.token_length = 20
    end

    allow_any_instance_of(MockAccessToken).to receive(:save!)
  end

  # For time compare, I allow up to 30 seconds difference
  #   as this lib doen't require milisecond precise
  let(:delta) { 30 }

  subject { OctopusAuth::Revoke.new(token).execute }

  context 'valid token' do
    before do
      access_token = MockAccessToken.new
      allow(MockAccessToken).to receive(:find_by).and_return(access_token)
    end

    let(:token) { '__VALID_TOKEN__' }

    it 'return asscess token with expired_at' do
      expect(subject.expired_at).to be_within(delta / 2).of(Time.now.utc - delta / 2)
    end
    it 'return inactive asscess token' do
      expect(subject.active).to eq(false)
    end
  end

  context 'invalid token' do
    before do
      allow(MockAccessToken).to receive(:find_by).and_return(nil)
    end

    let(:token) { '__INVALID_TOKEN__' }

    it 'raise exception' do
      expect { subject }.to raise_exception(OctopusAuth::Errors::TokenNotFoundError)
    end
  end
end
