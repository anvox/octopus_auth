module OctopusAuth
  class AccessScopeValidator
    def initialize(access_token)
      @access_token = access_token
      @access_scopes = (access_token.access_scopes || '').split(OctopusAuth.configuration.access_scopes_delimiter)
    end

    def valid?(*required_scopes, allow_wildcard: true)
      (allow_wildcard && access_all_scopes?) || required_scopes.any? { |scope| access_scopes.include?(scope.to_s) }
    end

    def self.valid?(access_token, *required_scopes, allow_wildcard: true)
      new(access_token).valid?(*required_scopes, allow_wildcard: allow_wildcard)
    end

    private

    attr_reader :access_token, :access_scopes

    def access_all_scopes?
      access_scopes.any? { |scope| scope == OctopusAuth.configuration.access_scopes_wildcard.to_s }
    end
  end
end
