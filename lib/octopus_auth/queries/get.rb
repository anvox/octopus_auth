module OctopusAuth
  module Queries
    class Get
      def initialize(token)
        @token = token
      end

      def execute
        return nil if @token.nil?

        access_token = OctopusAuth.configuration.model_class.where(token: @token).first
        return nil if access_token.nil?

        OctopusAuth::Decorators::Default.new(access_token)
      end
    end
  end
end
