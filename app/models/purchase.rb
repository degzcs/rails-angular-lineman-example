# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  provider_id                 :integer
#  origin_certificate_sequence :string(255)
#  gold_batch_id               :integer
#  amount                      :float
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#

class Purchase < ActiveRecord::Base
  mount_uploader :origin_certificate_file, AttachmentUploader
end
