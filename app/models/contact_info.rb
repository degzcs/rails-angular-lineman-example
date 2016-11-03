# == Schema Information
#
# Table name: contact_infos
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contact_id          :integer
#  contact_alegra_id   :integer
#  contact_alegra_sync :boolean          default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#

class ContactInfo < ActiveRecord::Base
end
