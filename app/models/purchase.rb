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
#

#TODO: change column name from amount to price
#TODO: extract origin_certicated* fields to a single table and make the association
class Purchase < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :user
  # belongs_to :provider
  belongs_to :gold_batch

  #
  # Fields
  #
  mount_uploader :origin_certificate_file, AttachmentUploader

  # This is the uniq code assigned to this purchase
  def reference
    Digest::MD5.hexdigest "#{origin_certificate_sequence}#{id}"
  end
end
