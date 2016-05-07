class Sale::Registration
  attr_accessor :sale, :selected_purchases

  def initialize
  end

  def call(options={})
    raise 'You must to provide a sale option' unless options[:sale].present?
    raise 'You must to provide a selected_purchases option' unless options[:selected_purchases].present?
    @sale = options[:sale]
    @selected_purchases = options[:selected_purchases]

    update_inventories(selected_purchases)
    register_sold_batches(sale, selected_purchases)
    ::Sale::CertificateGenerator.new.call(sale: sale)
  end

  #Update all inventories related after a sale
  def update_inventories(selected_purchases)
    selected_purchases.each do |item|
      purchase = Purchase.find(item['purchase_id'])
      amount_picked = item['amount_picked']
      new_remaining_amount = purchase.inventory.remaining_amount - amount_picked
      purchase.inventory.update_attribute(:remaining_amount,new_remaining_amount)
    end
  end
  # register all sold_batches for a sale
  def register_sold_batches(sale,selected_purchases)
    selected_purchases.each do |purchase|
      sale.batches.create(purchase_id: purchase['purchase_id'], grams_picked: purchase['amount_picked'])
    end
  end

end