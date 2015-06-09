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

class Office < ActiveRecord::Base

  belongs_to :company
  has_many :users

  validates :name, presence: true
  validates :company, presence: true
end
