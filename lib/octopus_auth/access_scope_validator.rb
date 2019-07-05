module OctopusAuth
  class AccessScopeValidator
    def initialize(access_token)
      @access_token = access_token
      @access_scopes = (access_token.try(:access_scopes) || '').split(OctopusAuth.configuration.access_scopes_delimiter)
    end

    def valid?(*required_scopes)
      access_all_scopes? || required_scopes.all? { |scope| access_scopes.include?(scope.to_s) }
    end

    def self.valid?(access_token, *required_scopes)
      self.new(access_token).valid?(*required_scopes)
    end

    private

    attr_reader :access_token, :access_scopes

    def access_all_scopes?
      access_scopes.any? { |scope| scope.to_s == OctopusAuth.configuration.access_scopes_wildcard.to_s }
    end
  end
end