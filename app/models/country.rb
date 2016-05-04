# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base

  #
  # Associations
  #

  has_many :states

  #
  # Validations
  #

  validates_uniqueness_of :name
end
