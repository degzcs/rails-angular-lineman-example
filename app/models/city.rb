# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  code       :string(255)
#

class City < ActiveRecord::Base

  #
  # Associations
  #

  has_many :population_centers
  belongs_to :state

  #
  # Delegations
  #

  delegate :code, to: :state, prefix: :state

  #
  # Validations
  #

  validates_uniqueness_of :name
end
