module OctopusAuth
  class Configuration
    attr_accessor :scopes
    attr_accessor :default_scope
    attr_accessor :token_life_time
    attr_accessor :token_length
    attr_accessor :model_class
  end
end
