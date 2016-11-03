# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  password_digest    :string(255)
#  reset_token        :string(255)
#  office_id          :integer
#  registration_state :string(255)
#  alegra_id          :integer
#  alegra_sync        :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  #
  # Audit Class
  #
  audited
  has_associated_audits

  include ::StateMachines::UserStates

  #
  # Associations
  #

  has_one :profile, dependent: :destroy
  has_many :purchases, dependent: :destroy, class_name: 'Order', foreign_key: 'buyer_id'
  has_many :sales, dependent: :destroy, class_name: 'Order', foreign_key: 'seller_id'
  has_one :personal_rucom, class_name: 'Rucom', as: :rucomeable
  has_many :credit_billings, dependent: :destroy
  has_many :contact_infos, dependent: :destroy
  belongs_to :office
  has_one :company, through: :office
  has_and_belongs_to_many :roles

  #
  # Validations
  #

  validates :email, presence: true, uniqueness: true, if: lambda { |user| user.trader?}
  validates :office, presence: true, if: :validate_office? # this field would be validated if user add some information related with company in the registration process.
  validates :personal_rucom, presence: true, if: :validate_personal_rucom? # the rucom has to be present for any user if he-she has no office asociated

  has_secure_password validations: false
  validates_presence_of :password, :on => :create, if: lambda { |user| user.trader?}
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  validates_presence_of :password_confirmation, if: lambda { |m| m.password.present? }

  #
  # Scopes
  #

  scope :order_by_id, -> { order('users.id DESC') }
  scope :find_by_name, ->(name){ joins(:profile).where("lower(profile.first_name) LIKE :first_name OR lower(profile.last_name) LIKE :last_name",
              { first_name: "%#{ name.downcase.gsub('%', '\%').gsub('_', '\_') }%", last_name: "%#{ name.downcase.gsub('%', '\%').gsub('_', '\_') }%"})}
  scope :find_by_document_number, -> (document_number){ joins(:profile).where("profiles.document_number LIKE :document_number",
              { document_number: "%#{ document_number.gsub('%', '\%').gsub('_', '\_') }%" }) }
  # static scope
  # scope :not_authorize_providers_users, -> { joins(:roles).where('roles.name <> ? ', 'authorized_provider') }
  scope :authorized_providers, -> {joins(:roles).where('roles.name = ?', 'authorized_provider')}
  # TODO: this name no make sense here. Update it asap!!!
  scope :providers, -> { joins(:profile).where('profiles.available_credits > ?', 0) }

  # Get users activity
  # NOTE: these names are in spanish because it is not clear yet how handle these categories and if the names are correct
  # I think all category names can be formatted when are entered by the scrapper , or eventually, when are get them directly from DB
  # 0. Barequero, 1. Chatarrero, 2. Solicitante de Legalización De Minería, 3. Beneficiario Área Reserva Especial,
  # 4. Consumidor, 5. Titular , 6. Subcontrato de operación
  # 7. Comercializador -> traders, NOTE: I think this kind of users are all users that can login in the platform
  # 8. Joyero, 9. Comprador Ocasional y 10. Exportacion

  scope :barequeros, -> { joins(:personal_rucom).where('rucoms.provider_type = ?', 'Barequero') }
  scope :chatarreros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Chatarrero')}
  scope :solicitantes, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Solicitante Legalización De Minería')}
  scope :beneficiarios, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial')}
  scope :consumidor, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Consumidor')}
  scope :mineros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Titular')}
  scope :subcontratados, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Subcontrato')}
  scope :casas_compra_venta, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Casa de Compraventa')}
  scope :barequeros_chatarreros, -> {joins(:personal_rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Barequero', 'Chatarrero')}
  scope :beneficiarios_mineros, -> {joins(:personal_rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial', 'Titular')}
  scope :comercializadores, -> {joins(office: [{company: :rucom}]).where('rucoms.provider_type = ?', 'Comercializadores')}
  # NOTE: It will be deprecated in order to use the role customers
  scope :clients, -> { includes(:personal_rucom).not_authorize_providers_users }
  # Finally, this scope gets all users that can be logged in the platform
  scope :system_users, -> { where('users.password_digest IS NOT NULL')}

  #
  # Calbacks
  #

  accepts_nested_attributes_for :purchases, :sales, :credit_billings, :office, :profile, :personal_rucom, :roles

  #
  # Delegates
  #

  delegate :available_credits, to: :profile
  delegate :legal_representative, to: :profile
  delegate :provider_type, to: :rucom

  #
  # Methods for MicroMachine
  #

  def user_complete
    if check_if_it_can_be_completed
      status.trigger(:complete)
    end
  end

  #
  # Instance Methods
  #

  # Checks if user can pass to the next state
  def check_if_it_can_be_completed
    self.are_set_all_attributes &&
      self.trader?
  end

  def there_are_unset_attributes
    self.email.blank? # || self.password.blank?
  end

  def are_set_all_attributes
    !self.email.blank? && !has_profile_or_rucom_unset_attributes
  end

  def has_profile_or_rucom_unset_attributes
    has_profile_unset_attributes || has_rucom_unset_attributes
  end

  def has_profile_unset_attributes
    self.profile.there_are_unset_attributes
  end

  def has_rucom_unset_attributes
    self.rucom.there_are_unset_attributes
  end

  # Get the user activity based on rucom, barequero (authorized provider)
  def activity
    self.authorized_provider? ? personal_rucom.activity : company.rucom.activity
  end

  def company_name
    company.try(:name)
  end

  # This method is about to be deprecated.
  def rucom_record
    rucom.try(:rucom_number)
  end

  def rucom_number
    rucom.try :rucom_number
  end

  def available_credits_based_on_user_role
    if has_office?
      self.office.company.legal_representative.profile.available_credits
    else
      self.profile.available_credits
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
    if authorized_provider? # external?
      personal_rucom = rucom
    else
     # NOTE: this line was remove it because the company rucom is set up in the company model not here
     # office.company.rucom = rucom if office.present?
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

  #
  # Roles
  #

  # to determine if a user is in a specific role
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def authorized_provider?
    self.roles.map(&:authorized_provider?).any?
  end

  def final_client?
    self.roles.map(&:final_client?).any?
  end

  def trader?
    self.roles.map(&:trader?).any?
  end

  def transporter?
    self.roles.map(&:transporter?).any?
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

  def state_basic?
    self.registration_state == 'basic' && there_are_unset_attributes
  end

  # Sync this user with Alegra
  # @param sync [ Boolean ] it is false by default to avoid synchroize user when it's not needed
  # @return [ Hash ]
  #           - success [ Boolean ]
  #           - errors [ Array ]
  def syncronize_with_alegra!(sync=false)
    service = Alegra::ContactSynchronize.new(self)
    service.call if sync
    self.errors.add(:alegra_sync, "El comercializador fue guardado pero no se ha sincronizado con Alegra. El error es: #{ service.response[:errors] }" ) if service.response[:errors].present?
    service.response
  end

  protected

  def validate_authorized_provider?
    if self.authorized_provider? && self.has_office?
      self.errors.add(:office, 'Los proveedores autorizados no pueden tener oficina')
    end
  end

  # NOTE: We are waiting the meeting with accounter to define the validations when a
  # trader is legal person and natural person and his relantionship with the model Office
  def validate_office?
    self.trader?
  end

  # NOTE: this conditional (!self.has_office?  && !self.trader?) is because we havent the feature to know if
  # user is natural or legal person.
  def validate_personal_rucom?
    (self.authorized_provider? && !self.has_office?) || (!self.has_office? && !self.trader?)
  end
end
