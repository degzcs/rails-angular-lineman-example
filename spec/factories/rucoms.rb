# == Schema Information
#
# Table name: rucoms
#
#  id              :integer          not null, primary key
#  rucom_number    :string(255)
#  name            :string(255)
#  original_name   :string(255)
#  minerals        :string(255)
#  location        :string(255)
#  status          :string(255)
#  provider_type   :string(255)
#  rucomeable_type :string(255)
#  rucomeable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :rucom do
    rucom_number { "RUCOM-20131220411-#{ Rucom.count }" }
    name { "Empresa falsa # #{ Rucom.count }" }
    original_name { "Empresa falsa # #{ Rucom.count }" }
    minerals { 'ORO' } # Plata or Platino
    location { '' }
    status { ['certificado', 'rechazado', 'vencido', 'en_tramite, pendiente_de_evaluacion'].sample }
    # Provider Types
    # 1) chatarrero, 2) barequero, 3) titular minero, 4) beneficiario de area de reserva especial, 5) solicitante de legalizacion, 6) subcontrato de formalizaion
    # TODO: Every name here have to be formatted with parameterize and underscore methods
    provider_type { ['titular', 'solicitante_legalizacion_de_mineria', 'beneficiario_area_reserva_especial', 'barequero', 'chatarrero', 'casa_de_compraventa'].sample }
  end
end
