# string :document_number
# string :type
# string :first_name
# string :last_name
# string :phone_number
# string :address

class Provider < ActiveRecord::Base
  has_one :company_info

  #
  # Instance Methods
  #
  
  # @return True if the provider has company_info related
  def is_company?
    self.company_info != nil
  end
end
