class AvailableTrazoroService < ActiveRecord::Base
  has_and_belongs_to_many :user_settings, :join_table => :plans
end
