# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#  city_id    :integer
#  address    :string(255)
#

class Office < ActiveRecord::Base

  #
  # Associations
  #

  has_many :users
  belongs_to :company
  belongs_to :city

  #
  # Validations
  #

  validates :name, presence: true
  validates :company, presence: true
  validates :city, presence: true
  validates :address, presence: true
end
