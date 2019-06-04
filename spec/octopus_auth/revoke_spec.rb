require 'spec_helper'

RSpec.describe OctopusAuth::Revoke do
  context 'valid token' do
    it 'return asscess token with expired_at'
    it 'return inactive asscess token'
  end

  context 'invalid token' do
    it 'raise exception'
  end
end
