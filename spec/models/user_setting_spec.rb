# == Schema Information
#
# Table name: user_settings
#
#  id           :integer          not null, primary key
#  state        :boolean
#  alegra_token :string(255)
#  profile_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

RSpec.describe UserSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
