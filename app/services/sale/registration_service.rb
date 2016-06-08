class Sale::RegistrationService
  attr_accessor :sale, :selected_purchases, :response
  attr_accessor :seller

  def initialize
  end

  def call(options={})
    raise 'You must to provide a sale_values option' if options[:sale_values].blank?
    raise 'You must to provide a seller option' if options[:seller].blank?
    raise 'You must to provide a gold_batch_values option' if options[:gold_batch_values].blank?
    raise 'You must to provide a selected_purchases option' if options[:selected_purchases].blank?
    @seller = options[:seller]
    @selected_purchases = options[:selected_purchases]
    @response = {}

    @sale = @seller.sales.build(options[:sale_values])
    @sale.build_gold_batch(options[:gold_batch_values])

    ActiveRecord::Base.transaction do
      @sale.save
      update_inventories(@selected_purchases)
      register_sold_batches(@sale, @selected_purchases)
      @response = ::Sale::CreatePurchaseFilesCollection.new.call(sale: @sale)
    end
  end

  # Update all inventories related with the current sale
  # @param selected_purchases [ Array ]
  def update_inventories(selected_purchases)
    selected_purchases.each do |item|
      purchase = Purchase.find(item['purchase_id'])
      amount_picked = item['amount_picked'].to_f
      new_remaining_amount = purchase.inventory.remaining_amount - amount_picked
      purchase.inventory.update_attribute(:remaining_amount, new_remaining_amount)
    end
    # TODO: it must add the amount of gold to the buyer. All operations here are related with the
    # inventory of the saler. To update the buyer it is needed to know
    # if he/she buys as a company or single person
  end

  # Register all sold_batches for a sale
  # @param selected_purchases [ Array ]
  def register_sold_batches(sale, selected_purchases)
    selected_purchases.each do |purchase|
      sale.batches.create(purchase_id: purchase['purchase_id'], grams_picked: purchase['amount_picked'])
    end
  end
end