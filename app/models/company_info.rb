# string :nit_number
# string :name
# string :city
# string :state
# string :country
# string :legal_representative
# string :id_type_legal_rep 
# string :email
# string :phone_number
#

class CompanyInfo < ActiveRecord::Base
  belongs_to :provider
end
