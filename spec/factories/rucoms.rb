# == Schema Information
#
# Table name: rucoms
#
#  idrucom            :string(90)       not null
#  rucom_record       :text
#  name               :text
#  status             :text
#  mineral            :text
#  location           :text
#  subcontract_number :text
#  mining_permit      :text
#  updated_at         :datetime
#  provider_type      :string(255)
#  num_rucom          :string(255)
#  id                 :integer          not null, primary key
#  rucomeable_type    :string(255)
#  rucomeable_id      :integer
#  trazoro            :boolean          default(FALSE), not null
#

FactoryGirl.define do
  factory :rucom do
    idrucom {
        Faker::Code.ean }
    rucom_record { Faker::Code.ean }
    num_rucom { Faker::Code.ean }
    name { Faker::Name.name }
    status { "active" }
    mineral { "ORO" }
    location { Faker::Address.city }
    subcontract_number { Faker::Company.ein }
    mining_permit { Faker::Code.ean }
    # Provider Types
    #1) chatarrero, 2) barequero, 3) titular minero, 4) beneficiario de area de reserva especial, 5) solicitante de legalizacion, 6) subcontrato de formalizaion
    provider_type {["Titular", "Solicitante Legalización De Minería", "Beneficiario Área Reserva Especial", "Barequero", "Chatarrero", "Casa de Compraventa"].sample}

      trait :for_clients do
        after(:build) do |rucom, eval|
            rucom.trazoro = true
            rucom.provider_type= ['Joyero','Comprador Ocasional', 'Exportacion'].sample
        end
      end

  end


end
