require 'spec_helper'

RSpec.describe OctopusAuth::Authenticator do
  let(:token) { '1234' }
  subject { OctopusAuth::Authenticator.new(token, :organization) }

  before do
    OctopusAuth.configure do |config|
      config.model_class = MockAccessToken
    end

    allow(MockAccessToken).to receive(:find_by).and_return(access_token)
  end

  context 'no token found' do
    let(:access_token) { nil }

    it 'return false' do
      expect(subject.authenticate).to eq(false)
    end
  end

  context 'inactive token' do
    let(:access_token) do
      at = MockAccessToken.new
      at.token = token
      at.expires_at = Time.now.utc + 1*60*60
      at.active = false
      at.scope = 'organization'

      at
    end

    it 'return false' do
      expect(subject.authenticate).to eq(false)
    end
  end

  context 'invalid scope' do
    let(:access_token) do
      at = MockAccessToken.new
      at.token = token
      at.expires_at = Time.now.utc + 1*60*60
      at.active = false
      at.scope = 'user'

      at
    end

    it 'return false' do
      expect(subject.authenticate).to eq(false)
    end
  end

  context 'validate expires at' do
    let(:access_token) do
      at = MockAccessToken.new
      at.token = token
      at.expires_at = expires_at
      at.active = true
      at.scope = 'organization'

      at.owner_id = 1234
      at.owner_type = 'Organization'

      at
    end

    context 'token has field expires_at in past' do
      let(:expires_at) { Time.now.utc - 1*60*60 }

      it 'return false' do
        expect(access_token).to receive(:update)
        expect(subject.authenticate).to eq(false)
      end
    end

    context 'token has field expires_at in future' do
      let(:expires_at) { Time.now.utc + 1*60*60 }

      it 'return true' do
        expect(access_token).not_to receive(:update)
        expect(subject.authenticate { |result| }).to eq(true)
      end

      it 'return correct result' do
        result = nil
        subject.authenticate do |success_result|
          result = success_result
        end

        expect(result).to             be
        expect(result.token).to       eq(token)
        expect(result.owner_id).to    eq(1234)
        expect(result.owner_type).to  eq('Organization')
        expect(result.scope).to       eq(:organization)
      end
    end
  end
end
