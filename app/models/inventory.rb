# == Schema Information
#
# Table name: inventories
#
#  id               :integer          not null, primary key
#  purchase_id      :integer
#  remaining_amount :float            not null
#  status           :boolean          default(TRUE), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Inventory < ActiveRecord::Base
  belongs_to :user
  validates :purchase_id , presence: true
  validates :remaining_amount , presence: true
end
