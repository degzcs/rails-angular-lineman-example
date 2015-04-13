# == Schema Information
#
# Table name: providers
#
#  id                         :integer          not null, primary key
#  document_number            :string(255)
#  first_name                 :string(255)
#  last_name                  :string(255)
#  phone_number               :string(255)
#  address                    :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  rucom_id                   :integer
#  identification_number_file :string(255)
#  rut_file                   :string(255)
#  mining_register_file       :string(255)
#  photo_file                 :string(255)
#  email                      :string(255)
#  population_center_id       :integer
#

# TODO: change  column name from identification_number_file to tableIdentification_document_file
class Provider < ActiveRecord::Base

  #
  # Associations
  #

  has_one :company_info
  mount_uploader :identification_number_file, AttachmentUploader
  mount_uploader :rut_file, AttachmentUploader
  mount_uploader :mining_register_file, AttachmentUploader
  mount_uploader :photo_file, AttachmentUploader
  
  #
  # Instance Methods
  #

  # @return True if the provider has company_info related
  def is_company?
    self.company_info != nil
  end

  # @return the rucom of the provider
  def rucom
    Rucom.find(self.rucom_id)
  end

  # @return the population_center of the provider
  def population_center
    PopulationCenter.find(self.population_center_id)
  end

  validates :document_number, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  # validates :rucom_id , presence: true
  validates :email, presence: true
  validates :population_center_id, presence: true

end
