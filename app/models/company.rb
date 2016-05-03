# == Schema Information
#
# Table name: companies
#
#  id                       :integer          not null, primary key
#  nit_number               :string(255)
#  name                     :string(255)
#  legal_representative     :string(255)
#  id_type_legal_rep        :string(255)
#  email                    :string(255)
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  id_number_legal_rep      :string(255)
#  chamber_of_commerce_file :string(255)
#  external                 :boolean          default(FALSE), not null
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#

class Company < ActiveRecord::Base

  has_many :offices, dependent: :destroy
  has_many :external_users
  has_one :rucom, as: :rucomeable

 #
 # Validations
 #

  validates :nit_number, presence: true
  validates :name, presence: true
  validates :legal_representative, presence: true
  validates :id_number_legal_rep, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :chamber_of_commerce_file, presence: true
  validates :rut_file, presence: true
  validates :mining_register_file, presence: true
  validates :rucom, presence: true

  # uploaders
  mount_uploader :rut_file, PdfUploader
  mount_uploader :mining_register_file, PdfUploader
  mount_uploader :chamber_of_commerce_file, PdfUploader

  #TODO: avoid destroy company if there are users associated to it.

end
