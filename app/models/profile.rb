# == Schema Information
#
# Table name: profiles
#
#  id                        :integer          not null, primary key
#  first_name                :string(255)
#  last_name                 :string(255)
#  document_number           :string(255)
#  phone_number              :string(255)
#  available_credits         :float
#  address                   :string(255)
#  rut_file                  :string(255)
#  photo_file                :string(255)
#  mining_authorization_file :text
#  legal_representative      :boolean
#  id_document_file          :text
#  nit_number                :string(255)
#  city_id                   :integer
#  created_at                :datetime
#  updated_at                :datetime
#  user_id                   :integer
#

class Profile < ActiveRecord::Base

  #
  # Associations
  #

  belongs_to :user
  belongs_to :city

  #
  # Validations
  #

  validates :first_name , presence: true
  validates :last_name , presence: true
  validates :document_number , presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  # TODO: change external feature to roles feature
  # validates :id_document_file, presence: true, unless: :external
  # validates :rut_file, presence: true
  # validates :mining_authorization_file, presence: true
  # validates :photo_file, presence: true, unless: :external
  validates :city, presence: true


  #
  # Uploaders
  #

  mount_uploader :id_document_file, DocumentUploader
  mount_uploader :photo_file, PhotoUploader
  mount_uploader :rut_file, DocumentUploader
  mount_uploader :mining_authorization_file, DocumentUploader

  #
  # Callbacks
  #

  after_initialize :init

  #
  # Instance Methods
  #

  def mining_register_file
    self.mining_authorization_file
  end

  #add available credits
  def add_available_credits(credits)
    new_amount = (available_credits + credits).round(2)
    update_attribute(:available_credits, new_amount)
  end

  protected


  def init
    self.available_credits ||= 0.0 #will set the default value only if it's nil
  end


end
