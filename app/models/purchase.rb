# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  provider_id                 :integer
#  origin_certificate_sequence :string(255)
#  gold_batch_id               :integer
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#  seller_picture              :string(255)
#

#TODO: extract origin_certicated* fields to a single table and make the association
class Purchase < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :user
  # belongs_to :provider
  belongs_to :gold_batch
  has_one :inventory

  #
  # Callbacks
  # 
  after_create :create_inventory

  #
  # Fields
  #
  mount_uploader :origin_certificate_file, AttachmentUploader
  mount_uploader :seller_picture, AttachmentUploader

  # This is the uniq code assigned to this purchase
  def reference_code
    Digest::MD5.hexdigest "#{origin_certificate_sequence}#{id}"
  end

  #Gets the provider of the purchase
  def provider
    Provider.find(self.provider_id)
  end

  protected 
    #After create the purchase it creates its own inventory with the remaining_amount value equals to the gold batch amount buyed
    def create_inventory
      Inventory.create(purchase_id: self.id, remaining_amount: self.gold_batch.grams)
    end

end
