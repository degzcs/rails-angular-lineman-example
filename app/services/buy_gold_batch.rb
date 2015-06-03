# There are almost  two types of purchases
# 1. when the current user (buyer) buy gold from provider who is no active member in the trazoro plataform
# the provider types under this category are: "chatarrero" y "barequero"
# 2. when the current user (buyer) buy gold from provider who is  an active user in the plataform
# the provider types under this category are: ""
#
class BuyGoldBatch
  attr_accessor :buyer
  attr_accessor :seller
  attr_accessor :purchase
  attr_accessor :purchase_hash
  attr_accessor :gold_batch_hash

  #
  # @params purchase_hash  [Hash]
  # @params bold_batch_hash  [Hash]
  # @params buyer [User]
  # @params seller [User]
  #
  def initialize(purchase_hash, gold_batch_hash, buyer, seller = nil)
    @buyer = buyer
    @purchase_hash = purchase_hash
    @gold_batch_hash = gold_batch_hash
  end

  #
  # @return [...]
  def buy!
   # create purchase
    @purchase = buyer.purchases.build(purchase_hash)
    @purchase.build_gold_batch(gold_batch_hash)

    if buyer.available_credits > 0
      # save purchase
       purchase.save

      #discount available credits
      buyer.available_credits = buyer.available_credits - gold_batch_hash['fine_grams'].to_f unless purchase.trazoro
      buyer.save
    else
      false
    end
  end

end