class BuyGoldBatch
  attr_accessor :user
  attr_accessor :purchase
  attr_accessor :purchase_hash
  attr_accessor :gold_batch_hash

  def initialize(user, purchase_hash, gold_batch_hash)
    @user = user
    @purchase_hash = purchase_hash
    @gold_batch_hash = gold_batch_hash
  end

  # @return [Boolean]
  def process!
   # create purchase
    @purchase = user.purchases.build(purchase_hash)
    @purchase.build_gold_batch(gold_batch_hash)

    # save purchase
     purchase.save
  end

end