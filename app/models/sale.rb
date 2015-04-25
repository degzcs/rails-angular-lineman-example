# == Schema Information
#
# Table name: sales
#
#  id            :integer          not null, primary key
#  courier_id    :integer
#  client_id     :integer
#  user_id       :integer
#  gold_batch_id :integer
#  grams         :float
#  barcode       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Sale < ActiveRecord::Base
  belongs_to :user
  belongs_to :gold_batch
  
  validates :courier_id, presence: true
  validates :client_id, presence: true
  validates :user_id, presence: true
  validates :grams, presence: true
  validates :gold_batch_id, presence: true

end
