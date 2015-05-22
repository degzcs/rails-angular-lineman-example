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
#  chamber_commerce_file    :string(255)
#  rucom_id                 :integer
#  company_id               :integer
#  population_center_id     :integer
#

class User < ActiveRecord::Base

	#
	# Associations
	#

	has_many :purchases
	has_many :sales
	has_many :credit_billings
	
	belongs_to :company 
	belongs_to :rucom #  NOTE: this is temporal becauses we don't have access to the real Rucom table just by the scrapper in python.
	belongs_to :population_center

	has_secure_password

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
	# Calbacks
	#

	after_initialize :init
	
	accepts_nested_attributes_for :purchases, :sales, :credit_billings, :rucom, :company, :population_center

	#
	# fields for save files by carrierwave
	#
	mount_uploader :document_number_file, PdfUploader
	mount_uploader :rut_file, PdfUploader
	mount_uploader :mining_register_file, PdfUploader
	mount_uploader :photo_file, PhotoUploader
	mount_uploader :chamber_commerce_file, PdfUploader

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

	def office
		'Trazoro Popayan'
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
