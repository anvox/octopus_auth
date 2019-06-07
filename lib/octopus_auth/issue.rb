require "octopus_auth/token_generator"

module OctopusAuth
  class Issue
    def initialize(scope, owner_type, owner_id, creator_id, expires_at: nil)
      @owner_type   = owner_type
      @owner_id     = owner_id
      @creator_id   = creator_id
      @scope        = scope.to_sym

      @expires_at   = expires_at
    end

    def execute
      access_token = OctopusAuth.configuration.model_class.new

      # Set attributes
      access_token.issued_at  = Time.now.utc
      if @expires_at
        access_token.expires_at = @expires_at
      else
        access_token.expires_at = access_token.issued_at + OctopusAuth.configuration.token_life_time
      end
      access_token.active     = true

      access_token.owner_type = @owner_type
      access_token.owner_id   = @owner_id
      access_token.creator_id = @creator_id

      access_token.scope      = filtered_scope
      access_token.token      = generate_token

      access_token.save!

      OctopusAuth::Decorators::Default.new(access_token)
    end

    private

    def filtered_scope
      if OctopusAuth.configuration.scopes.include?(@scope)
        return @scope
      end

      return OctopusAuth.configuration.default_scope
    end

    def generate_token
      OctopusAuth::TokenGenerator.unique_token
    end
  end
end
