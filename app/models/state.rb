# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state_code :string(255)      not null
#  country_id :integer
#

class State < ActiveRecord::Base

  #
  # Associations
  #

	has_many :cities
  belongs_to :country
end
