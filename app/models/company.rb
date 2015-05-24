# == Schema Information
#
# Table name: companies
#
#  id                   :integer          not null, primary key
#  nit_number           :string(255)
#  name                 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country              :string(255)
#  legal_representative :string(255)
#  id_type_legal_rep    :string(255)
#  email                :string(255)
#  phone_number         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  id_number_legal_rep  :string(255)
#

class Company < ActiveRecord::Base
  
  has_many :users
  has_many :external_users

  validates :nit_number, presence: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :legal_representative, presence: true
  validates :id_number_legal_rep, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
end
