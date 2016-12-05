# == Schema Information
#
# Table name: profiles
#
#  id                          :integer          not null, primary key
#  first_name                  :string(255)
#  last_name                   :string(255)
#  document_number             :string(255)
#  phone_number                :string(255)
#  available_credits           :float
#  address                     :string(255)
#  rut_file                    :string(255)
#  photo_file                  :string(255)
#  mining_authorization_file   :text
#  legal_representative        :boolean
#  id_document_file            :text
#  nit_number                  :string(255)
#  city_id                     :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  user_id                     :integer
#  habeas_data_agreetment_file :string(255)
#

class Profile < ActiveRecord::Base
  # TODO: remove this class asap!!
  class EmptyCredits < StandardError
  end

  #
  # Associations
  #

  belongs_to :user
  belongs_to :city
  has_one :setting, class_name: 'UserSetting', dependent: :destroy

  #
  # Audit Class
  #
  audited associated_with: :user

  #
  # Validations
  #

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :document_number, presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  validates :id_document_file, presence: true
  validates :rut_file, presence: true, unless: :authorized_provider? # NOTE: this is not necessary for this kind of user, but eventually it will be. So keep an eye on how the business is changing to remove this condition.
  validates :photo_file, presence: true
  validates :city, presence: true
  # This is a document that must be signed by the barequero or scrap dealer to authorize the handling of your information
  validates :habeas_data_agreetment_file, presence: true, if: :authorized_provider?

  #
  # Uploaders
  #

  mount_uploader :id_document_file, DocumentUploader
  mount_uploader :photo_file, PhotoUploader
  mount_uploader :rut_file, DocumentUploader
  mount_uploader :mining_authorization_file, DocumentUploader
  mount_uploader :habeas_data_agreetment_file, DocumentUploader

  #
  # Callbacks
  #

  after_initialize :init

  #
  # Delegates
  #

  delegate :name, to: :city, prefix: :city
  delegate :state_name, to: :city

  #
  # Instance Methods
  #

  def authorized_provider?
    user.authorized_provider? unless user.blank?
  end

  def mining_register_file
    self.mining_authorization_file
  end

  # TODO: change all this methods because there are a lot of inconsistencies with the names in the client side
  def phone
    self.phone_number
  end

  # TODO: this nit is completely different to company nit so fix it into the frontend asap!!
  def nit
    self.nit_number
  end

  # add available credits
  def add_available_credits(credits)
    new_amount = (available_credits + credits).round(2)
    update_attribute(:available_credits, new_amount)
  end

  # discount available credits amount
  def discount_available_credits(credits)
    new_amount = (available_credits - credits).round(2)
    raise EmptyCredits if new_amount <= 0
    update_attribute(:available_credits, new_amount)
  end

  def there_are_unset_attributes
    self.first_name.blank? ||
    self.last_name.blank? ||
    self.document_number.blank? ||
    self.phone.blank? ||
    self.address.blank? ||
    self.city_id.blank? ||
    self.photo_file.url.blank? ||
    self.id_document_file.url.blank? ||
    self.mining_register_file.url.blank?
  end

  def all_fields_authorized_provider
    self.first_name.present? &&
    self.last_name.present? &&
    self.document_number.present? &&
    self.phone.present? &&
    self.address.present? &&
    self.city_id.present? &&
    self.photo_file.url.present? &&
    self.id_document_file.url.present?
  end

  protected

  def init
    self.available_credits ||= 0.0 # will set the default value only if it's nil
  end
end
