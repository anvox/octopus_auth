module OctopusAuth
  class Authenticator
    UNAUTHORIZED = 'UNAUTHORIZED'.freeze

    def initialize(token, scope = nil)
      @token = token
      @scope = scope || OctopusAuth.configuration.default_scope
    end

    def authenticate
      return Failure.new(UNAUTHORIZED) if @token.blank?

      access_token = OctopusAuth.configuration.model_class.find_by(token: @token)

      return Failure.new(UNAUTHORIZED) unless access_token && access_token.active?

      if access_token.expires_at > Time.current
        access_token.update(active: false, expired_at: Time.current)

        Failure.new(UNAUTHORIZED)
      else
        Success.new(access_token)
      end
    end

    private

    class Failure
      def initialize(status, message = nil)
        @status = status
        @message = message
      end

      def success?
        false
      end
    end

    class Success
      def initialize(access_token)
        @access_token = access_token
      end

      def owner_id
        @access_token.owner_id
      end

      def owner_type
        @access_token.owner_type
      end

      def scope
        @access_token.scope.to_sym
      end

      def success?
        true
      end
    end
  end
end
