module OctopusAuth
  module Queries
    class Get
      def initialize(token)
        @token = token
      end

      def execute
        return nil if @token.nil?

        OctopusAuth.configuration.model_class.where(token: @token).first
      end
    end
  end
end
