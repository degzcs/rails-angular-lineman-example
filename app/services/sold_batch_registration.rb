class SoldBatchRegistration
  
  #Register a sold_batch when an inventory is updated after the sale
  def self.register_sold_batch(sale,purchase, amount_picked)
    sold_batch = sale.batches.create(purchase_id: purchase.id, grams_picked: amount_picked)
  end
end