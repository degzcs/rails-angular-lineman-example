# == Schema Information
#
# Table name: clients
#
#  id                   :integer          not null, primary key
#  first_name           :string(255)
#  last_name            :string(255)
#  phone_number         :string(255)
#  company_name         :string(255)
#  address              :string(255)
#  nit_company_number   :string(255)
#  id_document_type     :string(255)
#  id_document_number   :string(255)
#  client_type          :string(255)
#  rucom_id             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  population_center_id :integer
#  email                :string(255)
#

class Client < ActiveRecord::Base
  validates :id_document_number, presence: true
  validates :id_document_type, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :client_type , presence: true
  validates :email, presence: true
end
