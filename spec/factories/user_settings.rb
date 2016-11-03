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

FactoryGirl.define do
  factory :user_setting do
    state false
    alegra_token "MyString"
    profile nil
  end
end
