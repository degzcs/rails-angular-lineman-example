module V1
  module Entities
    class User < Grape::Entity
      expose :id, documentation: { type: "string", desc: "id of the user", example: '1' }
      expose :first_name, documentation: { type: "string", desc: " First user name", example: "Lourdez" }
      expose :last_name, documentation: { type: "string", desc: "Last user name", example: "Astre" }
      expose :email, documentation: { type: "string", desc: "email", example: "lourdezastre@test.com" }
      expose :document_number, documentation: { type: "string", desc: "email", example: "lourdezastre@test.com" }
      expose :access_token, documentation: { type: "string", desc: "email", example: "lourdezastre@test.com" } do |user, options|
        user.create_token
      end
      expose :available_credits , documentation: { type: "float", desc: "Available credits", example: 0.0 }
      expose :phone_number , documentation: { type: "string", desc: "Phone number", example: "312344626" }
    end
  end
end