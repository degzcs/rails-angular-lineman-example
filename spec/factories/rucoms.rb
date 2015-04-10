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
    provider_type {"Barequero"}
    num_rucom {Faker::Code.ean}
  end

end
