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

class UserSetting < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :profile
  has_and_belongs_to_many :available_trazoro_services, :join_table => :plans

  #
  # Validations
  #

  validates :state, inclusion: { in: [true, false] }
  validates :profile, presence: true
  validates_uniqueness_of :alegra_token
end
