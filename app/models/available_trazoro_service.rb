# == Schema Information
#
# Table name: available_trazoro_services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  credist    :float
#  created_at :datetime
#  updated_at :datetime
#

class AvailableTrazoroService < ActiveRecord::Base
  has_and_belongs_to_many :user_settings, :join_table => :plans
end
