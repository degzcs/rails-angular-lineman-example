# == Schema Information
#
# Table name: population_centers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  longitude  :decimal(, )
#  latitude   :decimal(, )
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#  code       :string(255)
#

class PopulationCenter < ActiveRecord::Base

  #
  # STI config
  #

  self.inheritance_column = 'sti_type'

  #
  # Associations
  #

  has_many :users
  has_many :external_users
  belongs_to :city

  #
  # Delegations
  #

  delegate :name, to: :city, prefix: :city
  delegate :code, to: :city, prefix: :city

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
