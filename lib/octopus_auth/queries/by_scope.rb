module OctopusAuth
  module Queries
    class ByScope
      def initialize(scope, owner_type, owner_id)
        @scope        = scope.to_sym
        @owner_type   = owner_type
        @owner_id     = owner_id
      end

      def execute
        relation.map do |token|
          OctopusAuth::Decorators::Default.new(token)
        end
      end

      private

      def relation
        OctopusAuth.configuration.model_class.where(scope: filtered_scope,
                                                    owner_type: @owner_type,
                                                    owner_id: @owner_id,
                                                    active: true)
      end

      def filtered_scope
        if OctopusAuth.configuration.scopes.include?(@scope)
          return @scope
        end

        return OctopusAuth.configuration.default_scope
      end
    end
  end
end
