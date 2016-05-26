# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)
#  last_name                :string(255)
#  email                    :string(255)
#  document_number          :string(255)
#  document_expedition_date :date
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  password_digest          :string(255)
#  available_credits        :float
#  reset_token              :string(255)
#  address                  :string(255)
#  rut_file                 :string(255)
#  photo_file               :string(255)
#  population_center_id     :integer
#  office_id                :integer
#  external                 :boolean          default(FALSE), not null
#  mining_register_file     :string(255)
#  legal_representative     :boolean          default(FALSE)
#  id_document_file         :text
#  nit_number               :string(255)
#  city_id                  :integer
#

# TODO: define a new name for mining_register_file, because this will contain one of these:
# 1. barequero ID file,
# 2. miner register file or
# 3. a resolution to guarantee that he/she can commercialize gold
# So, I think it could be named as mining_authorization_document and add another field to select the document type
class User < ActiveRecord::Base

  class EmptyCredits < StandardError
  end

  #
  # Virtual Attributes
  #

  #
  # Associations
  #

  has_many :purchases
  has_many :sales
  has_many :purchases_as_provider , class_name: "Purchase", as: :provider
  # TODO: urgent refactor this association and all logic associate with it.
  # The solution for all this kind of issues is create user roles and add cancancan gem to give access
  # and select this role when the sale will be done on the sale module/service
  has_many :sales_as_client, class_name: "Sale", as: :client
  has_one :personal_rucom, class_name: "Rucom",  as: :rucomeable

  has_many :credit_billings
  belongs_to :office
  has_one :company, through: :office
  belongs_to :city
  has_one :state, through: :city
  # TODO: create migration to remote this field
  belongs_to :population_center

  # #IMPORTANT : type 1. is dedicated to users without company and 7. to users without rucom
  # enum user_type: [ :barequero, :comercializador, :solicitante, :beneficiario, :consumidor, :titular, :subcontrato, :inscrito]

  #
  # Validations
  #

  validates :first_name , presence: true
  validates :last_name , presence: true
  validates :email, presence: true, uniqueness: true, unless: :external
  validates :document_number , presence: true
  #validates :document_expedition_date, presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  validates :id_document_file, presence: true, unless: :external
  #validates :rut_file, presence: true
  # validates :mining_register_file, presence: true
  validates :photo_file, presence: true, unless: :external
  validates :office, presence: true , if: :validate_office? # this field would be validated if user add some information related with company in the registration process.
  validates :city, presence: true
  validates :personal_rucom, presence: true, unless: :validate_personal_rucom? # the rucom has to be present for any user if he-she has no office asociated

  has_secure_password validations: false
  validates_presence_of :password, :on => :create, if: lambda { |user|  !user.external }
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  validates_presence_of     :password_confirmation, if: lambda { |m| m.password.present? }

  #
  # Scopes
  #

  scope :order_by_id, -> {order("users.id DESC")}
  scope :find_by_name, ->(name){where("lower(first_name) LIKE :first_name OR lower(last_name) LIKE :last_name",
              {first_name: "%#{name.downcase.gsub('%', '\%').gsub('_', '\_')}%", last_name: "%#{name.downcase.gsub('%', '\%').gsub('_', '\_')}%"})}
  scope :find_by_document_number, -> (document_number){where("document_number LIKE :document_number",
              {document_number: "%#{document_number.gsub('%', '\%').gsub('_', '\_')}%"})}


  scope :external_user_ids_with_personal_rucom, -> {includes(:personal_rucom).where('(users.external IS TRUE) AND ( rucoms.provider_type NOT IN (?) )', ['Joyero', 'Comprador Ocasional', 'Exportacion']).references(:personal_rucom).pluck(:id)}
  scope :external_user_ids_with_company_rucom, -> {includes(office: [{company: :rucom}]).where('(users.external IS TRUE) AND ( rucoms.provider_type NOT IN (?) )', ['Joyero', 'Comprador Ocasional', 'Exportacion']).references(:office).pluck(:id)}

  def self.external_users
    ids = [external_user_ids_with_company_rucom, external_user_ids_with_personal_rucom].flatten.compact.uniq
    User.where(id: ids)
  end

  scope :providers, -> {where('users.available_credits > ?', 0)}

  # Get external users activity
  # NOTE: these names are in spanish because it is not clear yet how handle these categories and if the names are correct
  # I think all category names can be formatted when are entered by the scrapper , or eventually, when are get them directly from DB
  # 0. Barequero, 1. Chatarrero, 2. Solicitante de Legalización De Minería, 3. Beneficiario Área Reserva Especial,
  # 4. Consumidor, 5. Titular , 6. Subcontrato de operación

  scope :barequeros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Barequero')}
  scope :chatarreros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Chatarrero')}
  scope :solicitantes, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Solicitante Legalización De Minería')}
  scope :beneficiarios, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial')}
  scope :consumidor, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Consumidor')}
  scope :mineros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Titular')}
  scope :subcontratados, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Subcontrato')}
  scope :casas_compra_venta, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Casa de Compraventa')}
  scope :barequeros_chatarreros, -> {joins(:personal_rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Barequero', 'Chatarrero')}
  scope :beneficiarios_mineros, -> {joins(:personal_rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial', 'Titular')}

  # Get users activity
  # 7. Comercializador -> traders, NOTE: I think this kind of users are all users that can login in the platform
  scope :comercializadores, -> {joins(office: [{company: :rucom}]).where('rucoms.provider_type = ?', 'Comercializadores')}

  # NOTE: the next definition is deprecated and all this users have to be upgrade to the new way to categorize them by roles.
  # NOTE: the external user who don't have rucom and only buy gold, he is called clients, they are:
  # 8. Joyero, 9. Comprador Ocasional y 10. Exportacion
  scope :client_ids_with_fake_personal_rucom, -> {joins(:personal_rucom).where('rucoms.provider_type IN (?) ', ['Joyero', 'Comprador Ocasional', 'Exportacion', 'Comercializadores']).pluck(:id)}
  scope :client_ids_with_fake_company_rucom, -> {includes(office: [{company: :rucom}]).where('rucoms.provider_type IN (?) ', ['Joyero', 'Comprador Ocasional', 'Exportacion', 'Comercializadores']).references(:office).pluck(:id)}

  # IMPROVE: this class method is just temporal solucition to retrieve all clients
  def self.clients_with_fake_rucom
    ids = [client_ids_with_fake_personal_rucom, client_ids_with_fake_company_rucom].flatten.compact.uniq
    User.where(id: ids)
  end

  # Finally, this scope gets all users that can be logged in the platform
  scope :system_users, -> { where('users.password_digest IS NOT NULL')}

  scope :system_user_ids, -> { where('users.password_digest IS NOT NULL').pluck(:id)}

  # scope :clients, -> {includes(:personal_rucom).where('(users.password_digest IS NOT NULL) OR ( rucoms.provider_type IN (?) )', ['Joyero', 'Comprador Ocasional', 'Exportacion']).references(:personal_rucom)}
  def self.clients
    ids =  [client_ids_with_fake_personal_rucom, client_ids_with_fake_company_rucom, system_user_ids].flatten.compact.uniq
    User.where(id: ids)
  end

  #
  # Calbacks
  #

  after_initialize :init

  accepts_nested_attributes_for :purchases, :sales, :credit_billings, :office, :population_center

  #
  # fields for save files by carrierwave
  #
  mount_uploader :id_document_file, DocumentUploader
  mount_uploader :photo_file, PhotoUploader
  mount_uploader :rut_file, DocumentUploader
  mount_uploader :mining_register_file, DocumentUploader

  #
  # Delegates
  #

  delegate :name, to: :city, prefix: :city
  delegate :name, to: :state, prefix: :state
  #
  # Instance Methods
  #

  #
  # Get the user activity based on rucom
  def activity
    self.external && self.office.blank? ? personal_rucom.activity : company.rucom.activity
  end

  def company_name
    company.try(:name)
  end

  # TODO: change all this methods because there are a lot of inconsistencies with the names in the client side
  def phone
    phone_number
  end

  # TODO: this nit is completely different to company nit so fix it into the frontend asap!!
  def nit
    self.nit_number
  end

  def rucom_record
    rucom.try(:rucom_record)
  end

  def available_credits_based_on_user_role
    if has_office?
      self.office.company.legal_representative.available_credits
    else
     self.available_credits
    end
  end

  # IMPORTANT Get if the user or external user belongs to a company
  def rucom
    if self.office.present?
      self.office.company.try(:rucom)
    else
      self.try(:personal_rucom)
    end
  end

  # Set rucom based on type of user
  def rucom=(rucom)
    if self.external?
      personal_rucom=rucom
    else
      office.company.rucom = rucom if office.present?
    end
  end

  # @return [String] whith the JWT to send the client
  def create_token
    payload = {
      user_id: self.id.to_s,
      iat: Time.now.to_i,
      exp: 14.days.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base);
  end

  #discount available credits amount
  def discount_available_credits(credits)
    new_amount = (available_credits - credits).round(2)
    raise EmptyCredits if new_amount <= 0
    update_attribute(:available_credits,new_amount)
  end

  #add available credits
  def add_available_credits(credits)
    new_amount = (available_credits + credits).round(2)
    update_attribute(:available_credits,new_amount)
  end

  # NOTE: This method is just and alias to avoid break the app, this field was removed and it will be deleted from the rest of the project asap.
  def document_number_file
    self.id_document_file
  end

  #
  # Class Methods
  #

  # @return [Boolean] true if the token is valid and false if it's not
  def self.valid?(token)
    begin
     JWT.decode(token, Rails.application.secrets.secret_key_base)
    rescue
     false
    end
  end

  def has_office?
    self.office.present?
  end

  protected

  def init
    self.available_credits ||= 0.0 #will set the default value only if it's nil
  end

  # NOTE: all users marked as an external are users which will belong to the client role.
  def validate_office?
    self.external && !self.personal_rucom
  end

  def validate_personal_rucom?
    self.has_office? || self.legal_representative
  end

end
