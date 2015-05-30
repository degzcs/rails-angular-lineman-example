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
#  user_type                :integer          default(1), not null
#  office_id                :integer
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
	has_one :rucom , as: :trazoro_user

	has_many :credit_billings
	belongs_to :office
	has_one :company, through: :office
	belongs_to :population_center

	has_secure_password

  #ENUM USER TYPES:
  # 0. Barequero, 1. Comercializador, 2. Solicitante de Legalización De Minería, 3. Beneficiario Área Reserva Especial,
  # 4. Consumidor, 5. Titular , 6. Subcontrato de operación , 7. Inscrito

  #IMPORTANT : type 1. is dedicated to users without company and 7. to users without rucom

  enum user_type: [ :barequero, :comercializador, :solicitante, :beneficiario, :consumidor, :titular, :subcontrato, :inscrito]

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
	validates :document_number_file, presence: true
	validates :rut_file, presence: true
	validates :mining_register_file, presence: true
	validates :photo_file, presence: true
	validates :office, presence: true
	validates :population_center, presence: true

	#
	# Calbacks
	#

	after_initialize :init

	accepts_nested_attributes_for :purchases, :sales, :credit_billings, :rucom, :office, :population_center

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

	def company_name
		company.name
	end

	# TODO: change all this methods because there are a lot of inconsistencies with the names in the client side
	def phone
		phone_number
	end

	#IMPROVE:  this value introduce inconsistencies in the transactions!!
	def city
		population_center.try(:city)
	end

	#IMPROVE:  this value introduce inconsistencies in the transactions!!
	def nit
		company.nit_number
	end

	def rucom_record
		rucom.rucom_record
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

end
