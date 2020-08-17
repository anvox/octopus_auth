require 'spec_helper'

RSpec.describe OctopusAuth::AccessScopeValidator do
  let(:required_scopes) { ['scope_1', 'scope_2'] }

  subject { described_class.new(access_token) }

  before do
    OctopusAuth.configure do |config|
      config.model_class = MockAccessToken
      config.access_scopes_delimiter = ' '
      config.access_scopes_wildcard = 'all'
    end
  end

  context 'when token has no required scope' do
    let(:access_token) do
      MockAccessToken.new.tap do |token|
        token.access_scopes = 'scope_3'
      end
    end

    it 'returns false' do
      expect(subject.valid?(*required_scopes)).to eq false
    end
  end

  context 'when token has some required scopes' do
    let(:access_token) do
      MockAccessToken.new.tap do |token|
        token.access_scopes = 'scope_3 scope_1'
      end
    end

    it 'returns true' do
      expect(subject.valid?(*required_scopes)).to eq true
    end
  end

  context 'when token has all required scopes' do
    let(:access_token) do
      MockAccessToken.new.tap do |token|
        token.access_scopes = 'scope_2 scope_1'
      end
    end

    it 'returns true' do
      expect(subject.valid?(*required_scopes)).to eq true
    end
  end

  context 'when token has wildcard scope' do
    let(:access_token) do
      MockAccessToken.new.tap do |token|
        token.access_scopes = 'all'
      end
    end

    context 'when wildcard scope is allowing' do
      it 'returns true' do
        expect(subject.valid?(*required_scopes)).to eq true
      end
    end

    context 'when wildcard scope is not allowing' do
      it 'returns true' do
        expect(subject.valid?(*required_scopes, allow_wildcard: false)).to eq false
      end
    end
  end
end
