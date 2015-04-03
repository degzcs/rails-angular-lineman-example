# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  state_code :string(255)      not null
#  city_code  :string(255)      not null
#

class City < ActiveRecord::Base
  belongs_to :state
end
