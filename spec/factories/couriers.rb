# == Schema Information
#
# Table name: couriers
#
#  id                 :integer          not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  phone_number       :string(255)
#  company_name       :string(255)
#  address            :string(255)
#  nit_company_number :string(255)
#  id_document_type   :string(255)
#  id_document_number :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

FactoryGirl.define do
  factory :courier do
    first_name { "courier name" }
    last_name { "courier last_name" }
    phone_number { 1231231 }
    company_name { "courier company_name" }
    address { "courier address"}
    nit_company_number { 1234567890 }
    id_document_type { "id_document_type courier" }
    id_document_number { 1234456763 }
  end
end
