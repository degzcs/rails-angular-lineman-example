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
    # Exposes the arguments to get them from  Model Rucom
    class Rucom < Grape::Entity
      expose :id, documentation: { type: 'text', desc: 'id of the Rucom', example: '1' }
      expose :rucom_number, documentation: { type: 'string', desc: 'Rucom Number', example: 'RUCOM-20131220411' }
      expose :name, documentation: { type: 'text', desc: 'Name', example: 'Juan Perez' }
      expose :status, documentation: { type: 'text', desc: 'Status', example: 'Certificado' }
      expose :minerals, documentation: { type: 'text', desc: 'Mineral', example: 'Oro , gemas etc..' }
      expose :location, documentation: { type: 'text', desc: 'location', example: '...' }
      expose :provider_type, documentation: { type: 'string', desc: 'provider type', example: '...' }
    end
  end
end
