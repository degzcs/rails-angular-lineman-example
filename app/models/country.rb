class Country < ActiveRecord::Base

  #
  # Associations
  #
   has_many :states
end
