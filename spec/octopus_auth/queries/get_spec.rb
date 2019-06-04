require 'spec_helper'

RSpec.describe OctopusAuth::Queries::Get do
  subject { OctopusAuth::Queries::Get.new(token).execute }

  before do
    OctopusAuth.configure do |config|
      config.model_class = MockAccessToken
      config.token_life_time = 1.*60*60 # 1 hour
      config.scopes = [:organization, :user]
      config.default_scope = :user
      config.token_length = 20
    end
  end

  context 'valid token' do
    let(:token) { '__VALID__TOKEN__' }
    let(:access_token) { MockAccessToken.new }
    before do
      allow(MockAccessToken).to receive(:where).with(anything).and_return(MockAccessToken)
      allow(MockAccessToken).to receive(:first).and_return(access_token)
    end

    it 'return access token' do
      expect(subject).to be_a(OctopusAuth::Decorators::Default)
    end
  end

  context 'invalid token' do
    let(:token) { '__INVALID__TOKEN__' }
    before do
      allow(MockAccessToken).to receive(:where).with(anything).and_return(MockAccessToken)
      allow(MockAccessToken).to receive(:first).and_return(nil)
    end

    it 'return nil' do
      expect(subject).to be_nil
    end
  end

  context 'nil token' do
    let(:token) { nil }
    before do
      allow(MockAccessToken).to receive(:where).with(anything).and_return(MockAccessToken)
      allow(MockAccessToken).to receive(:first).and_return(nil)
    end

    it 'return nil' do
      expect(subject).to be_nil
    end
  end
end
