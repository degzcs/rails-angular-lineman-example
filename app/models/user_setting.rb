class UserSetting < ActiveRecord::Base
  belongs_to :profile
  has_and_belongs_to_many :available_trazoro_service, :join_table => :plans
end
