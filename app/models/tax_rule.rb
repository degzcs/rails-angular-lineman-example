# == Schema Information
#
# Table name: tax_rules
#
#  id            :integer          not null, primary key
#  tax_id        :integer
#  seller_regime :string(255)
#  buyer_regime  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

# TaxRule class storage the rules to apply the taxes
class TaxRule < ActiveRecord::Base
  belongs_to :tax

  validates :tax_id, presence: true
  validates :transaction_type, presence: true
  validates :seller_regime, presence: true
  validates :buyer_regime, presence: true
end
