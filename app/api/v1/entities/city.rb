#  id         :integer          
#  name       :string(255)
#  state_id   :integer
#  state_code :string(255)      
#  city_code  :string(255)      
#

module V1
  module Entities
    class City < Grape::Entity
      expose :id, documentation: { type: "text", desc: "City id", example: '1' }
      expose :name, documentation: { type: "text", desc: "City name", example: "Medellin" }
      expose :city_code, documentation: { type: "text", desc: "City code", example: "05001" }
      expose :state_id, documentation: { type: "text", desc: "State id", example: "1" }
      expose :state_code, documentation: { type: "text", desc: "State code", example: "05" }
    end
  end
end