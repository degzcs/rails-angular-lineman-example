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
      @sale.save! # This save both the new sale and gold_batch
      selected_gold_batches = find_gold_batches_from(@selected_purchase_ids)
      mark_as_sold!(selected_gold_batches)
      update_inventories(selected_gold_batches)
      register_sold_batches(@sale, selected_gold_batches)
      @response = ::Sale::CreatePurchaseFilesCollection.new.call(sale: @sale)
      # @response = ::Sale::ProofOfSale::GenerationService.new.call(sale: @sale)
    end
  end

  # Update all inventories related with the current sale
  # @param gold_batches [ Array ]
  def update_inventories(gold_batches)
    # Seller
    sold_fine_grams = sum_fine_grams_from(gold_batches)
    available_fine_grams = seller.inventory.remaining_amount - sold_fine_grams
    set_fine_grams_on_hand_for!(seller.inventory, available_fine_grams)

    # Buyer
    # TODO: pending sale trazoro type ->
    # It must to add the amount of gold to the buyer. All operations here are related with the
    # inventory of the saler. To update the buyer it is needed to know
    # if he/she buys as a company or single person
  end

  # @param gold_batch [ Array ]
  # @return [ Array ]
  def mark_as_sold!(gold_batches)
    gold_batches.map { |gold_batch| gold_batch.update(sold: true) }
  end

  def sum_fine_grams_from(gold_batches)
    gold_batches.inject(0){ |res, gold_batch| res + gold_batch.fine_grams }
  end

  # Sets the amount of gold available on the Inventory
  # @return [ Boolean ]
  def set_fine_grams_on_hand_for!(inventory, new_value)
    inventory.update_attributes(remaining_amount: new_value)
  end

  # Select the correct seller based on he is a natual or legal person.
  # @param current_user [ User ]
  # @return [ User ]
  def seller_based_on(current_user)
    if current_user.has_office?
      current_user.company.legal_representative
    else
      current_user
    end
  end

  # @param selected_purchase_ids [ Array ]
  # @return [ ActiveRecord ] with all GoldBatches selected by the user
  def find_gold_batches_from(selected_purchase_ids)
    seller.purchases.where(id: selected_purchase_ids).includes(:gold_batch).map(&:gold_batch)
  end

  # Register all sold_batches for a sale
  # @param selected_purchase_ids [ Array ]
  # @return [ Array ] with all updated GoldBatches
  def register_sold_batches(sale, gold_batches)
    gold_batches.map do |gold_batch|
      # NOTE: the amount of grams picked is the same thank the fine grams from the gold batch, due the origin certificate cannot be split. This field is deprecated and will be removed soon.
      sale.batches.create(gold_batch_id: gold_batch.id, grams_picked: gold_batch.fine_grams)
    end
  end
end