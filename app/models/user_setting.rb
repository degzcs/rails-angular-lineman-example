# == Schema Information
#
# Table name: user_settings
#
#  id                        :integer          not null, primary key
#  state                     :boolean          default(FALSE)
#  alegra_token              :string(255)
#  profile_id                :integer
#  created_at                :datetime
#  updated_at                :datetime
#  fine_gram_value           :float
#  last_transaction_sequence :integer          default(0)
#  regime_type               :string(255)
#  activity_code             :string(255)
#  scope_of_operation        :string(255)
#  organization_type         :string(255)
#  self_holding_agent        :boolean
#

class UserSetting < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :profile
  has_and_belongs_to_many :trazoro_services, :join_table => :plans, class_name: 'AvailableTrazoroService'

  #
  # Validations
  #

  validates :state, inclusion: { in: [true, false] }
  validates :profile, presence: true
  validates_uniqueness_of :alegra_token
  validates :fine_gram_value, numericality: true
end
