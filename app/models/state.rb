# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state_code :string(255)      not null
#

class State < ActiveRecord::Base
	has_many :cities
end
