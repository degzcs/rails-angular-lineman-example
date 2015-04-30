# == Schema Information
#
# Table name: rucoms
#
#  id                 :integer          not null, primary key
#  idrucom            :string(90)       not null
#  rucom_record       :text
#  name               :text
#  status             :text
#  mineral            :text
#  location           :text
#  subcontract_number :text
#  mining_permit      :text
#  updated_at         :datetime         default(2015-04-10 01:25:41 UTC)
#  provider_type      :string(255)
#  num_rucom          :string(255)
#

FactoryGirl.define do
  factory :rucom do
    idrucom {Faker::Code.ean}
    rucom_record {Faker::Code.ean}
    name {Faker::Name.name}
    status {"active"}
    mineral {"ORO"}
    location {Faker::Address.city}
    subcontract_number {Faker::Company.ein}
    mining_permit {Faker::Code.ean}
    # Provider Types
    #1) chatarrero, 2) barequero, 3) titular minero, 4) beneficiario de area de reserva especial, 5) solicitante de legalizacion, 6) subcontrato de formalizaion
    provider_type {["barequero", "chatarrero", "minero", "beneficiario", "solicitante", "subcontrato" ].sample}
    num_rucom {Faker::Code.ean}
  end

end
