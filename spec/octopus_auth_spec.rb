RSpec.describe OctopusAuth do
  it "has a version number" do
    expect(OctopusAuth::VERSION).not_to be nil
  end

  it "has config methods" do
    expect(OctopusAuth).to respond_to(:configure)
    expect(OctopusAuth).to respond_to(:reset)
  end
end
