# PucAccount class to load the tax module Puc
class PucAccount < ActiveRecord::Base
  has_many :taxes
  has_many :transaction_movements

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  def self.accounts_for_select
    PucAccount.all.map { |r| ["#{r.code} - #{r.name}", r.id] }
  end
end
