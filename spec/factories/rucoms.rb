# == Schema Information
#
# Table name: rucoms
#
#  id                 :string          not null, primary key
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


FactoryGirl.define do
  factory :rucom do
    rucom_record "A rucom record "
    name {Faker::Name.name}
    status {"active"}
    mineral {"A mineral"}
    location {Faker::Address.city}
    subcontract_number {Faker::Company.ein}
    mining_permit {"A mining permit"}
    provider_type {"Berequerou"}
    num_rucom {Faker::Code.ean}
  end

end
