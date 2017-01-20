# == Schema Information
#
# Table name: rut_activities
#
#  id   :integer          not null, primary key
#  code :string(255)
#  name :string(255)
#

# TaxRule class storage the rules to apply the taxes
class RutActivity < ActiveRecord::Base

  # 
  #  Associations
  #  
  has_and_belongs_to_many :user_settings, :join_table => :user_setting_rut_activities

  # 
  #  validations
  #  
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end