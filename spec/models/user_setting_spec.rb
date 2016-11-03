# == Schema Information
#
# Table name: user_settings
#
#  id              :integer          not null, primary key
#  state           :boolean          default(FALSE)
#  alegra_token    :string(255)
#  profile_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  fine_gram_value :float
#

require 'spec_helper'

RSpec.describe UserSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
