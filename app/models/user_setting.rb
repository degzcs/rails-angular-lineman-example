# == Schema Information
#
# Table name: user_settings
#
#  id              :integer          not null, primary key
#  state           :boolean
#  alegra_token    :string(255)
#  profile_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  fine_gram_value :float
#

class UserSetting < ActiveRecord::Base
  belongs_to :profile
  has_and_belongs_to_many :available_trazoro_service, :join_table => :plans
end
