# string :nit_number
# string :name
# string :city
# string :state
# string :country
# string :legal_representative
# string :id_type_legal_rep 
# string :email
# string :phone_number
#

class CompanyInfo < ActiveRecord::Base
  belongs_to :provider

  validates :nit_number, presence: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :legal_representative, presence: true
  validates :id_type_legal_rep, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :provider_id, presence: true
end
