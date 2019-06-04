require 'spec_helper'

RSpec.describe OctopusAuth::Queries::ByScope do
  before do
    OctopusAuth.configure do |config|
      config.model_class = MockAccessToken
      config.token_life_time = 1.*60*60 # 1 hour
      config.scopes = [:organization, :user]
      config.default_scope = :user
      config.token_length = 20
    end
  end

  subject { OctopusAuth::Queries::ByScope.new(scope, 'Organization', 1234).execute }

  context 'valid scope' do
    let(:scope) { :organization }

    it 'query active record' do
      expect(MockAccessToken).to receive(:where).with(scope: :organization, owner_type: 'Organization', owner_id: 1234, active: true).and_return([])

      expect(subject).to eq([])
    end

    it 'return decorated access token' do
      allow(MockAccessToken).to receive(:where).with(scope: :organization, owner_type: 'Organization', owner_id: 1234, active: true).and_return([MockAccessToken.new, MockAccessToken.new])

      result = subject
      expect(result.count).to eq(2)
      result.each do |item|
        expect(item).to be_a(OctopusAuth::Decorators::Default)
      end
    end
  end

  context 'invalid scope' do
    let(:scope) { :invalid_scope }

    it 'query active record with default scope' do
      expect(MockAccessToken).to receive(:where).with(scope: :user, owner_type: 'Organization', owner_id: 1234, active: true).and_return([])

      expect(subject).to eq([])
    end

    it 'return decorated access token' do
      allow(MockAccessToken).to receive(:where).with(scope: :user, owner_type: 'Organization', owner_id: 1234, active: true).and_return([MockAccessToken.new, MockAccessToken.new])

      result = subject
      expect(result.count).to eq(2)
      result.each do |item|
        expect(item).to be_a(OctopusAuth::Decorators::Default)
      end
    end
  end
end
