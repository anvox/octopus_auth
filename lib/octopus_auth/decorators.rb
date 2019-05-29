module OctopusAuth
  module Decorators
    ATTRIBUTES = [
      :token,
      :created_at, # TODO: [AV] Remove.
      :issued_at, #        Keep here just for compatible reason, use `issued_at` instead
      :active,
      :expires_at,
      :scope,
      :owner_id,
      :owner_type,
      :creator_id
    ]
  end
end

require "octopus_auth/decorators/default"
