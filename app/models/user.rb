# first_name Varchar (45)
# last_name Varchar (45)
# email Varchar (45)
# document_number Varchar (45)
# document_expedition_date Time 
# phone_number Varchar (45)
# password Varchar (45)

class User < ActiveRecord::Base


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

end