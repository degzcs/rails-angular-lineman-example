# == Schema Information
#
# Table name: population_centers
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  longitude              :decimal(, )
#  latitude               :decimal(, )
#  population_center_type :string(255)
#  city_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  population_center_code :string(255)      not null
#  city_code              :string(255)      not null
#

class PopulationCenter < ActiveRecord::Base
  belongs_to :city
  has_many :users
  has_many :external_users
  def city_name
    #city.name if city
  end

  def state_name
    #city.state.name if city.state
  end
end
