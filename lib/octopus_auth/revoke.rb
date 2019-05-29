module OctopusAuth
  class Revoke
    def initialize(access_token_value)
      @access_token = OctopusAuth.configuration.model_class.find_by(token: access_token_value)

      unless @access_token
        raise OctopusAuth::Errors::TokenNotFoundError.new("API Access token #{access_token_value} is not found")
      end
    end

    def execute
      @access_token.expired_at = Time.current
      @access_token.active = false

      @access_token.save!

      OctopusAuth::Decorators::Default.new(@access_token)
    end
  end
end
