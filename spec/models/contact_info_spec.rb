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

require 'spec_helper'

RSpec.describe ContactInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
