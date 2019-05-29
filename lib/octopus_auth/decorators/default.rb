module OctopusAuth
  module Decorators
    class Default
      def initialize(token_model)
        @token_model = token_model
      end

      OctopusAuth::Decorators::ATTRIBUTES.each do |m|
        define_method(m) do
          @token_model.send(m)
        end
      end

      def to_h
        OctopusAuth::Decorators::ATTRIBUTES.inject({}) do |carry, item|
          carry[item] = @token_model.send(item)

          carry
        end
      end

      alias_method :to_hash, :to_h
    end
  end
end
