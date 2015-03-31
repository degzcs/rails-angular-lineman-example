# == Schema Information
#
# Table name: rucoms
#
#  idrucom            :string(90)       not null, primary key
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
#

FactoryGirl.define do
  factory :rucom do
    idrucom "MyString"
record "MyText"
name "MyText"
status "MyText"
mineral "MyText"
location "MyText"
subcontract_number "MyText"
mining_permit "MyText"
  end

end
