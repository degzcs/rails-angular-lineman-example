# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  buyer_id   :integer
#  seller_id  :integer
#  type       :string(255)
#  code       :string(255)
#  price      :string(255)
#  trazoro    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Order < ActiveRecord::Base

  #
  # STI config
  #

  self.inheritance_column = 'sti_type'

  #
  # Associations
  #

  belongs_to :buyer_inventory, class_name: "Inventory"
  belongs_to :seller_inventory, class_name: "Inventory"
  belongs_to :courier
  has_one :buyer, through: :buyer_inventory
  has_one :seller, through: :seller_inventory
  has_one :gold_batch, class_name: "GoldBatch", as: :goldomable
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy
  has_many :batches, class_name: 'SoldBatch' #=> The model is SoldBatch but for legibility purpouses is renamed to batch (batches*)

end
