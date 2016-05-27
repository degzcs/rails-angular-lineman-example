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
# Associations
#

has_and_belongs_to_many :users

#
# Validations
#

validates :name, presence: true
end
