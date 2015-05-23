# == Schema Information
#
# Table name: external_users
#
#  id                       :integer          not null, primary key
#  document_number          :string(255)
#  first_name               :string(255)
#  last_name                :string(255)
#  phone_number             :string(255)
#  address                  :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  rucom_id                 :integer
#  document_number_file     :string(255)
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  photo_file               :string(255)
#  email                    :string(255)
#  population_center_id     :integer
#  chamber_commerce_file    :string(255)
#  company_id               :integer
#  document_expedition_date :date
#

# TODO: change  column name from identification_number_file to tableIdentification_document_file
class ExternalUser < ActiveRecord::Base

  #
  # Associations
  #
  
  has_many :purchases, as: :provider
  belongs_to :company
  belongs_to :rucom
  belongs_to :population_center

  mount_uploader :document_number_file, PdfUploader
  mount_uploader :rut_file, PdfUploader
  mount_uploader :mining_register_file, PdfUploader
  mount_uploader :photo_file, PhotoUploader
  mount_uploader :chamber_commerce_file, PdfUploader


  #
  # Validations
  #
  validates :first_name , presence: true
  validates :last_name , presence: true
  validates :email, presence: true
  validates :document_number , presence: true
  validates :document_expedition_date, presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  validates :rucom_id, presence: true
  validates :document_number_file, presence: true
  validates :rut_file, presence: true
  validates :mining_register_file, presence: true
  validates :photo_file, presence: true
  validates :chamber_commerce_file, presence: true
  validates :rucom_id, presence: true
  validates :company, presence: true
  validates :population_center, presence: true

  #
  # Scopes
  #
  #IMPROVE: This is temporal because the rumcom implementation will be changed (integration with the legacy system)
  # Provider Types
  #1) chatarrero, 2) barequero, 3) titular minero, 4) beneficiario de area de reserva especial, 5) solicitante de legalizacion, 6) subcontrato de formalizaion
  # I don't know how name this scopes in english and that make sense at the same time
  scope :chatarreros, -> {joins(:rucom).where('rucoms.provider_type = ?', 'Chatarrero')}
  scope :barequeros, -> {joins(:rucom).where('rucoms.provider_type = ?', 'Barequero')}
  scope :barequeros_chatarreros, -> {joins(:rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Barequero', 'Chatarrero')}
  scope :beneficiarios_mineros, -> {joins(:rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial', 'Titular')}
  scope :mineros, -> {joins(:rucom).where('rucoms.provider_type = ?', 'Titular')}
  scope :beneficiarios, -> {joins(:rucom).where('rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial')}
  scope :solicitantes, -> {joins(:rucom).where('rucoms.provider_type = ?', 'Solicitante Legalización De Minería')}
  scope :subcontratados, -> {joins(:rucom).where('rucoms.provider_type = ?', 'Comercializadores')}
  #
  # Instance Methods
  #

  # @return True if the provider has company related
  def is_company?
    self.company != nil
  end

  # @return the rucom of the provider
  # def rucom
  #   Rucom.find(self.rucom_id)
  # end

  def type
    rucom.provider_type
  end

end
