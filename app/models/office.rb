# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

# TODO: add city_id and associate this with city model
class Office < ActiveRecord::Base

  #
  # Associations
  #

  has_many :users
  belongs_to :company

  #
  # Validations
  #

  validates :name, presence: true
  validates :company, presence: true
end
