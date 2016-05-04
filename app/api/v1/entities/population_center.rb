#  id                     :integer
#  name                   :string(255)
#  longitude              :decimal(, )
#  latitude               :decimal(, )
#  population_center_type :string(255)
#  city_id                :integer
#  population_center_code :string(255)
#  city_code              :string(255)
#

module V1
  module Entities
    class PopulationCenter < Grape::Entity
      expose :id, documentation: { type: "text", desc: "Population center id", example: '1' }
      expose :name, documentation: { type: "text", desc: "Population center name", example: "Medellin" }
      expose :longitude, documentation: { type: "decimal", desc: "Population center longitude coordinate", example: "-47.0023301" } do |population_center, options|
        population_center.longitude.to_s
      end
      expose :latitude, documentation: { type: "decimal", desc: "Population center latitude coordinate", example: "123.4354999" } do |population_center, options|
        population_center.latitude.to_s
      end
      expose :population_center_type, documentation: { type: "text", desc: "Population center type", example: "CP, C, IPM" } do |population_center, options|
        # TODO: upgrade frond-end to accept this the correct value
        population_center.type.to_s
      end
      expose :population_center_code, documentation: { type: "text", desc: "Population center code", example: "05001000" } do |population_center, options|
        # TODO: upgrade frond-end to accept this the correct value
        population_center.code.to_s
      end
      expose :city_id, documentation: { type: "text", desc: "City id", example: "1" }
      expose :city_code, documentation: { type: "text", desc: "City code", example: "05001" }
    end
  end
end