# Tax class storage the taxes for the puc accounts
class Tax < ActiveRecord::Base
  belongs_to :puc_account
  has_many :tax_rules

  validates :puc_account_id, presence: true
  validates :name, presence: true
  validates :reference, presence: true
  validates :porcent, presence: true
end
