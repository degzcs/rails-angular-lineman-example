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
#

class User < ActiveRecord::Base

	#
	# Associations
	#

	has_many :purchases
	has_many :sales
	has_many :credit_billings
	has_secure_password

	#
	# Calbacks
	#

	after_initialize :init
	before_save :save_client

	#
	# Instance Methods
	#

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
