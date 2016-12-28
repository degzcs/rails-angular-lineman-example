# TaxRule class storage the rules to apply the taxes
class RutActivity < ActiveRecord::Base

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
