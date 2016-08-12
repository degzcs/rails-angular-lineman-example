# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  #
  # Constants
  #

  TYPES = %w(trader final_client transporter authorized_producer)

  #
  # Associations
  #

  has_and_belongs_to_many :users

  #
  # Validations
  #

  validates :name, presence: true
  validates_uniqueness_of :name

  #
  # Instace methods
  #

  def authorized_producer?
    self.name == 'authorized_producer'
  end

  def final_client?
    self.name == 'final_client'
  end

  def trader?
    self.name == 'trader'
  end

  def transporter?
    self.name == 'transporter'
  end
end
