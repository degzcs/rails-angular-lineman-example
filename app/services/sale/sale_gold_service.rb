
module Sale
  # Service SaleGoldService
  class SaleGoldService
    attr_reader :sale_order, :selected_purchase_ids, :seller, :buyer, :order_hash, :gold_batch_hash
    attr_accessor :response

    def initialize
      @response = {}
      @response[:errors] = []
    end

    # @param options [ Hash ]
    # @return [ Hash ]
    def call(options = {})
      validate_options(options)
      @seller = seller_based_on(options[:current_user])
      @order_hash = options[:order_hash]
      @gold_batch_hash = options[:gold_batch_hash]
      # @buyer= buyer
      @selected_purchase_ids = options[:selected_purchase_ids]
      sale!
    end

    private

    # @return [ Hash ] with the success or errors
    def sale!
      ActiveRecord::Base.transaction do
        sale_order = setup_sale_order!
        selected_gold_batches = find_gold_batches_from(selected_purchase_ids)
        mark_as_sold!(selected_gold_batches)
        # update_inventories(selected_gold_batches)
        # TODO: raise an error if the user try to sold more gold than it has.
        register_sold_batches(sale_order, selected_gold_batches)
        response = ::Sale::PurchaseFilesCollection::Generation.new.call(sale_order: @sale_order)
        response = ::Alegra::Traders::ContactSynchronize.new(seller: sale_order.seller, buyer: sale_order.buyer).call if APP_CONFIG[:ALEGRA_SYNC]
        pdf_generation_service = ::PdfGeneration.new
        response = pdf_generation_service.call(
          order: sale_order,
          # signature_picture: signature_picture
          draw_pdf_service: ::Sale::ProofOfSale::DrawPDF,
          document_type: 'equivalent_document' # TODO: invoice here
        )

        shipment_service = Shipment::ShipmentService.new
        response = shipment_service.call(
          current_user: @seller,
          order: sale_order
        )
      end
      response
    end

    # Creates a basic sale order with the correct values
    # @return [ Order ]
    def setup_sale_order!
      order_hash.merge!(type: 'sale')
      @sale_order = seller.sales.build(order_hash)
      @sale_order.build_gold_batch(gold_batch_hash.deep_symbolize_keys)
      # TODO: send email, sms or other service to buyer
      @sale_order.send_info!
      response[:success] = Order.audit_as(seller) { @sale_order.save! } # This save both the new sale and gold_batch
      @sale_order
    end

    # @param gold_batch [ Array ]
    # @return [ Array ]
    def mark_as_sold!(gold_batches)
      gold_batches.map { |gold_batch| gold_batch.update(sold: true) }
    end

    # @param gold_batch [ GoldBatch ]
    # @return [ Float ]
    def sum_fine_grams_from(gold_batches)
      gold_batches.inject(0) { |res, gold_batch| res + gold_batch.fine_grams }
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

    # Validates the params passed to this service
    # @param options [ Hash ]
    def validate_options(options)
      raise 'You must to provide a order_hash option' if options[:order_hash].blank?
      raise 'You must to provide a current_user option' if options[:current_user].blank?
      raise 'You must to provide a gold_batch_hash option' if options[:gold_batch_hash].blank?
      raise 'You must to provide a selected_purchase_ids option' if options[:selected_purchase_ids].blank?
    end
  end
end
