#  id         :integer
#  name       :string(255)
#  state_code :string(255)
#

module V1
  module Entities
    class State < Grape::Entity
      expose :id, documentation: { type: "text", desc: "State id", example: '1' }
      expose :name, documentation: { type: "text", desc: "State name", example: "Antioquia" }
      expose :state_code, documentation: { type: "text", desc: "State code", example: "05" }
    end
  end
end