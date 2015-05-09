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
#  company_info_id          :integer
#  population_center_id     :integer
#

class User < ActiveRecord::Base

	#
	# Associations
	#

	has_many :purchases
	has_many :sales
	has_many :credit_billings
	belongs_to :rucom #  NOTE: this is temporal becauses we don't have access to the real Rucom table just by the scrapper in python.
	belongs_to :company_info #TODO: this model will be renamed to Company so the association have to be renamed too.
	belongs_to :population_center

	has_secure_password

	#
	# Calbacks
	#

	after_initialize :init
	before_save :save_client

	accepts_nested_attributes_for :purchases, :sales, :credit_billings, :rucom, :company_info, :population_center

	#
	# fields for save files by carrierwave
	#
	mount_uploader :document_number_file, AttachmentUploader
	mount_uploader :rut_file, AttachmentUploader
	mount_uploader :mining_register_file, AttachmentUploader
	mount_uploader :photo_file, AttachmentUploader
	mount_uploader :chamber_commerce_file, AttachmentUploader

	#
	# Instance Methods
	#

	def company_name
		company_info.name
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
		company_info.nit_number
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

	# NOTE: what is Client class for?... I think is better use a Single-Table Inheritance approach here!
	# NOTE2: Also this client is created but without a implicit relation/association with the current user
	  def save_client

			client_hash = { "first_name" => self.first_name,
											"last_name" => self.last_name,
											"phone_number" => self.phone_number,
											"id_document_type" => 'CC',
											"id_document_number" => self.document_number,
											"client_type" => 'Comercializador',
											"email" => self.email}
										#	"rucom_id" => 1, #provisional
										#	"population_center_id" => 1} #provisional

			client = Client.new(client_hash)

			if !client.save
				errors.add(:email,'Error al crear este usuario  como cliente')
			end
		end

end
