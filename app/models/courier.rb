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

class Courier < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  validates :id_document_type, presence: true
  validates :id_document_number, presence: true

end