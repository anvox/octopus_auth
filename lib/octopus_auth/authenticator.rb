module OctopusAuth
  class Authenticator
    def initialize(token, scope = nil)
      @token = token.to_s
      @scope = scope || OctopusAuth.configuration.default_scope
    end

    def authenticate
      return false if @token.empty?

      access_token = OctopusAuth.configuration.model_class.find_by(token: @token)
      return false unless access_token && valid?(access_token)

      if access_token.expires_at.utc < Time.now.utc
        unless OctopusAuth.configuration.model_readonly
          access_token.update(active: false, expired_at: Time.now.utc)
        end
        return false
      end

      yield build_success_result(access_token)
      true
    end

    private

    def valid?(access_token)
      access_token.active? &&
        !access_token.expired_at &&
        access_token.scope.to_sym == @scope
    end

    ResultObject = Struct.new(:token, :owner_id, :owner_type, :scope)
    def build_success_result(access_token)
      ResultObject.new(access_token.token,
                       access_token.owner_id,
                       access_token.owner_type,
                       access_token.scope.to_sym)
    end
  end
end
