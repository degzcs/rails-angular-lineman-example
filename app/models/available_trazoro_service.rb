# == Schema Information
#
# Table name: available_trazoro_services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  credits    :float
#

class AvailableTrazoroService < ActiveRecord::Base
  #
  # Associations
  #

  has_and_belongs_to_many :user_settings, :join_table => :plans

  #
  # Validations
  #

  validates :name, presence: true
  validates :credits, presence: true
  validates :credits, numericality: true
end
