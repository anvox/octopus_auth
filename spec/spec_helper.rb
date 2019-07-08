require "bundler/setup"
require "octopus_auth"
require 'pry-byebug'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class MockAccessToken
  attr_accessor :id
  attr_accessor :token
  attr_accessor :created_at
  attr_accessor :issued_at
  attr_accessor :active
  attr_accessor :expires_at
  attr_accessor :expired_at
  attr_accessor :scope
  attr_accessor :owner_id
  attr_accessor :owner_type
  attr_accessor :creator_id
  attr_accessor :access_scopes

  def active?
    !!active
  end
end
