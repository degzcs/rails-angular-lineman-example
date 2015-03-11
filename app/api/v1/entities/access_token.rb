module V1
  module Entities
    class AccessToken < Grape::Entity
      expose :access_token, documentation: { type: "string", desc: "Real access token", example: "most_secure_password" }
      expose :expires_in, documentation: { type: "string", desc: "expiration time (1 day)", example: "2014-06-09T13:50:52-05:00" }
    end
  end
end
