require 'spec_helper'

RSpec.describe OctopusAuth::Issue do
  before do
    OctopusAuth.configure do |config|
      config.model_class = MockAccessToken
      config.token_life_time = 1.*60*60 # 1 hour
      config.scopes = [:organization, :user]
      config.default_scope = :user
      config.token_length = 20
    end

    allow(MockAccessToken).to receive(:where).with(anything).and_return(MockAccessToken)
    allow(MockAccessToken).to receive(:exists?).and_return(false)
    allow_any_instance_of(MockAccessToken).to receive(:save!)
    allow(OctopusAuth::TokenGenerator).to receive(:unique_token).and_return('__RANDOM_TOKEN__')
  end

  # For time compare, I allow up to 30 seconds difference
  #   as this lib doen't require milisecond precise
  let(:delta) { 30 }

  context 'happy case' do
    subject { OctopusAuth::Issue.new(:organization, 'Organization', 1234, 5432).execute }

    it 'generate token from token generator' do
      expect(subject.token).to eq('__RANDOM_TOKEN__')
    end

    it 'scope data' do
      expect(subject.scope).to      eq(:organization)
      expect(subject.owner_type).to eq('Organization')
      expect(subject.owner_id).to   eq(1234)
      expect(subject.creator_id).to eq(5432)
    end

    it 'is active' do
      expect(subject.active).to eq(true)
    end

    it 'issued_at tracked at now' do
      expect(subject.issued_at).to be_within(delta / 2).of(Time.now.utc - delta / 2)
    end

    it 'expires_at set at next 1 hour' do
      expect(subject.expires_at).to be_within(1*60*60 + delta / 2).of(Time.now.utc + 1*60*60 - delta / 2)
    end
  end
end
