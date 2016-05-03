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

  #
  # Associations
  #

  has_many :users
  has_many :external_users
  belongs_to :city

  #
  # Delegation
  #

  delegate :name, to: :city, prefix: :city

  #
  # Validation
  #

  validates :city, presence: true

  #
  # Instance Methods
  #

  def state_name
    city.state.name if city.state
  end
end
