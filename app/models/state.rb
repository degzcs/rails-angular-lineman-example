# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  country_id :integer
#  code       :string(255)
#

class State < ActiveRecord::Base

  #
  # Associations
  #

	has_many :cities
  belongs_to :country

  #
  # Validations
  #

  validates_uniqueness_of :name
end
