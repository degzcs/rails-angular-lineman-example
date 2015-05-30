# == Schema Information
#
# Table name: external_clients
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

# this class is like User but wiht more fields, so why don't use Single-Table Inheritance (STI) instead create a new model?
class ExternalClient < ActiveRecord::Base

  #
  # Instance Methods
  #

  # @return the rucom of the client
  def rucom
    # IMPROVE: what is the reason to don't use an association (eg has_one :rucom) instead this?
    Rucom.find(self.rucom_id) if (self.rucom_id)
  end

  # @return the population_center of the provider
  def population_center
    # IMPROVE: what is the reason to don't use an association (eg has_one :population_center) instead this?
    PopulationCenter.find(self.population_center_id) if (self.population_center_id)
  end

  validates :id_document_number, presence: true
  validates :id_document_type, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :client_type , presence: true
  validates :email, presence: true
end
