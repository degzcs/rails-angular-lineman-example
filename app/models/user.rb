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
#  document_number_file     :string(255)
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  photo_file               :string(255)
#  population_center_id     :integer
#  office_id                :integer
#  external                 :boolean          default(FALSE), not null
#

class User < ActiveRecord::Base

	class EmptyCredits < StandardError
	end
	#
	# Associations
	#

	has_many :purchases
	has_many :sales
	has_many :purchases_as_provider , class_name: "Purchase", as: :provider
	has_many :sales_as_client, class_name: "Sale", as: :client
	has_one :personal_rucom, class_name: "Rucom",  as: :rucomeable

	has_many :credit_billings
	belongs_to :office
	has_one :company, through: :office
	belongs_to :population_center

  # #IMPORTANT : type 1. is dedicated to users without company and 7. to users without rucom
  # enum user_type: [ :barequero, :comercializador, :solicitante, :beneficiario, :consumidor, :titular, :subcontrato, :inscrito]

	#
	# Validations
	#

	validates :first_name , presence: true
	validates :last_name , presence: true
	validates :email, presence: true
	validates :document_number , presence: true
	#validates :document_expedition_date, presence: true
	validates :phone_number, presence: true
	validates :address, presence: true
	validates :document_number_file, presence: true
	#validates :rut_file, presence: true
	#validates :mining_register_file, presence: true
	validates :photo_file, presence: true
	validates :office, presence: true , unless: :external # this field would be validated if user add some information related with company in the registration process.
	validates :population_center, presence: true
	validates :personal_rucom, presence: true, unless: :has_office # the rucom has to be present for any user if has no office asociated

	has_secure_password validations: false
	validates_presence_of :password, :on => :create, if: lambda { |user|  !user.external }
	validates_confirmation_of :password, if: lambda { |m| m.password.present? }
	 validates_presence_of     :password_confirmation, if: lambda { |m| m.password.present? }


	#
	# Scopes
	#

	scope :external_users, -> {where(external: true)}
	scope :providers, -> {where('users.available_credits > ?', 0)}

	# Get external users activity
	# these names are in spanish because is still not clear how handle these categories and if the names are correct
	# 0. Barequero, 1. Chatarrero, 2. Solicitante de Legalización De Minería, 3. Beneficiario Área Reserva Especial,
	# 4. Consumidor, 5. Titular , 6. Subcontrato de operación

	scope :barequeros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Barequero')}
	scope :chatarreros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Chatarrero')}
	scope :solicitantes, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Solicitante Legalización De Minería')}
	scope :beneficiarios, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial')}
	scope :consumidor, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Consumidor')}
	scope :mineros, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'Titular')}
	scope :subcontratados, -> {joins(:personal_rucom).where('rucoms.provider_type = ?', 'subcontrato')}
	scope :barequeros_chatarreros, -> {joins(:personal_rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Barequero', 'Chatarrero')}
	scope :beneficiarios_mineros, -> {joins(:personal_rucom).where('rucoms.provider_type = ? OR rucoms.provider_type = ?', 'Beneficiario Área Reserva Especial', 'Titular')}

	# Get users activiry
	# 7. Comercializador -> traders, NOTE: I think this kind of users are all users that can login in the platform
	scope :comercializadores, -> {joins(office: [{company: :rucom}]).where('rucoms.provider_type = ?', 'Comercializador')}

	#
	# Calbacks
	#

	after_initialize :init

	accepts_nested_attributes_for :purchases, :sales, :credit_billings, :office, :population_center

	#
	# fields for save files by carrierwave
	#
	mount_uploader :document_number_file, PdfUploader
	mount_uploader :rut_file, PdfUploader
	mount_uploader :mining_register_file, PdfUploader
	mount_uploader :photo_file, PhotoUploader

	#
	# Instance Methods
	#

	#
	# Get the user activity  based on rucom
	def activity
		self.external ? personal_rucom.activity :  company.rucom.activity
	end

	def company_name
		company.try(:name)
	end

	# TODO: change all this methods because there are a lot of inconsistencies with the names in the client side
	def phone
		phone_number
	end

	#IMPROVE:  this value introduce inconsistencies in the transactions!!
	def city
		population_center.try(:city)
	end

	def state
		city.try(:state)
	end

	#IMPROVE:  this value introduce inconsistencies in the transactions!!
	def nit
		company.try(:nit_number)
	end

	def rucom_record
		rucom.try(:rucom_record)
	end

	# IMPORTANT Get if the user or external user belongs to a company
	def rucom
		unless self.company
			personal_rucom
		else
			office.try(:company).try(:rucom)
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

	# def office
	# 	'Trazoro Popayan'
	# end


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

	protected

		def init
		  self.available_credits  ||= 0.0           #will set the default value only if it's nil
		end

		def has_office
			self.office  != nil
		end

end
