# ApplyTax class storage the rules to apply the taxes
class ApplyTax < ActiveRecord::Base
  belongs_to :tax

  validates :tax_id, presence: true
  validates :seller_regime, presence: true
  validates :buyer_regime, presence: true
end
