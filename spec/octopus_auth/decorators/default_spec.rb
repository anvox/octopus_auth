require 'spec_helper'

RSpec.describe OctopusAuth::Decorators::Default do
  subject { OctopusAuth::Decorators::Default.new(MockAccessToken.new) }
  it 'has defined attributes' do
    [
      :id,
      :token,
      :created_at,
      :issued_at,
      :active,
      :expires_at,
      :expired_at,
      :scope,
      :owner_id,
      :owner_type,
      :creator_id
    ].each do|attribute_name|
      expect(subject).to respond_to(attribute_name)
    end
  end

  let(:empty_decorated) do
    {
      active: nil,
      created_at: nil,
      creator_id: nil,
      expired_at: nil,
      expires_at: nil,
      id: nil,
      issued_at: nil,
      owner_id: nil,
      owner_type: nil,
      scope: nil,
      token: nil
    }
  end
  it 'is able to convert to hash' do
    expect(subject.to_h).to eq(empty_decorated)
  end
end
