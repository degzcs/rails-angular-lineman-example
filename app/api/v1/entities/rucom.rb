#  rucom_record       :text
#  name               :text
#  status             :text
#  mineral            :text
#  location           :text
#  subcontract_number :text
#  mining_permit      :text
#  updated_at         :datetime         default(2015-03-31 06:22:05 UTC)
#  provider_type      :string(255)
#  num_rucom          :string(255)
#

module V1
  module Entities
    class Rucom < Grape::Entity
      expose :id, documentation: { type: "text", desc: "id of the Rucom", example: '1' }
      expose :rucom_record, documentation: { type: "text", desc: "Rucom record", example: "Rucom20&233" }
      expose :name, documentation: { type: "text", desc: "Name", example: "Juan Perez" }
      expose :status, documentation: { type: "text", desc: "Status", example: "Active" }
      expose :mineral, documentation: { type: "text", desc: "Mineral", example: "Oro , gemas etc.." }
      expose :location, documentation: { type: "text", desc: "location", example: "..." }
      expose :subcontract_number, documentation: { type: "text", desc: "subcontract number", example: "..." }
      expose :mining_permit, documentation: { type: "text", desc: "mining permit", example: "..." }
      expose :updated_at, documentation: { type: "datetime", desc: "updated at", example: "..." }
      expose :provider_type, documentation: { type: "string", desc: "provider type", example: "..." }
      expose :num_rucom, documentation: { type: "string", desc: "num rucom", example: "..." }
    end
  end
end