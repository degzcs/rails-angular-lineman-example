# TaxRule class storage the rules to apply the taxes
class RutActivity < ActiveRecord::Base
  has_and_belongs_to_many :user_settings

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
