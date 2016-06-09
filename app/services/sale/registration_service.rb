class Sale::RegistrationService
  attr_accessor :sale, :selected_purchase_ids, :response
  attr_accessor :seller

  def initialize
  end

  def call(options={})
    raise 'You must to provide a sale_hash option' if options[:sale_hash].blank?
    raise 'You must to provide a current_user option' if options[:current_user].blank?
    raise 'You must to provide a gold_batch_hash option' if options[:gold_batch_hash].blank?
    raise 'You must to provide a selected_purchase_ids option' if options[:selected_purchase_ids].blank?
    @seller = seller_based_on(options[:current_user])
    @selected_purchase_ids = options[:selected_purchase_ids]
    @response = {}

    @sale = @seller.inventory.sales.build(options[:sale_hash])
    @sale.build_gold_batch(options[:gold_batch_hash])

    ActiveRecord::Base.transaction do
      @sale.save! # save both the new sale and gold_batch
      update_inventories(@selected_purchase_ids)
      # register_sold_batches(@sale, @selected_purchase_ids)
      @response = ::Sale::CreatePurchaseFilesCollection.new.call(sale: @sale)
    end
  end

  # Update all inventories related with the current sale
  # @param selected_purchase_ids [ Array ]
  def update_inventories(selected_purchase_ids)
    # Seller
    sold_fine_grams = []
    seller.purchases.where(id: selected_purchase_ids).each do |purchase|
      # amount_picked = item['amount_picked'].to_f
      mark_as_sold!(purchase.gold_batch)
      sold_fine_grams << purchase.gold_batch.fine_grams
    end
    available_fine_grams = seller.inventory.remaining_amount - sold_fine_grams.sum
    fine_grams_on_hand_for!(seller.inventory, available_fine_grams)

    # Buyer
    # TODO: pending sale trazoro type ->
    # It must to add the amount of gold to the buyer. All operations here are related with the
    # inventory of the saler. To update the buyer it is needed to know
    # if he/she buys as a company or single person
  end

  def mark_as_sold!(gold_batch)
    gold_batch.update_attributes(sold: true)
  end

  def fine_grams_on_hand_for!(inventory, new_value)
    inventory.update_attributes(remaining_amount: new_value)
  end

  def seller_based_on(current_user)
    if current_user.has_office?
      current_user.company.legal_representative
    else
      current_user
    end
  end

  # Register all sold_batches for a sale
  # @param selected_purchase_ids [ Array ]
  def register_sold_batches(sale, selected_purchase_ids)
    # selected_purchase_ids.each do |purchase|
    #   sale.batches.create(purchase_id: purchase['purchase_id'], grams_picked: purchase['amount_picked'])
    # end
  end
end