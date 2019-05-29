module OctopusAuth
  class TokenGenerator
    class << self
      def unique_token
        loop do
          token = generate(OctopusAuth.configuration.token_length)
          break token unless OctopusAuth.configuration.model_class.where(token: token).exists?
        end
      end

      private

      def generate(length)
        SecureRandom.hex(length / 2)
      end
    end
  end
end
