class SaleRegistration
  #Update all inventories related after a sale
  def self.update_inventories(selectedPurchases)
    selectedPurchases.each do |item|
      purchase = Purchase.find(item['purchase_id'])
      amount_picked = item['amount_picked']
      new_remaining_amount = purchase.inventory.remaining_amount - amount_picked
      purchase.inventory.update_attribute(:remaining_amount,new_remaining_amount)
    end
  end
  # register all sold_batches for a sale
  def self.register_sold_batches(sale,selectedPurchases)
    selectedPurchases.each do |purchase|
      sale.batches.create(purchase_id: purchase['purchase_id'], grams_picked: purchase['amount_picked'])
    end
  end

end