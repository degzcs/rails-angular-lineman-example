module Marketplace
  # Service SaleService
  class SaleService
    attr_reader :sale_order, :selected_purchase_ids, :seller, :order_hash, :gold_batch_hash,
                :current_user, :remote_address
    attr_accessor :response

    def initialize
      @response = {}
      @response[:errors] = []
    end

    # @param options [ Hash ]
    # @return [ Hash ]
    def call(options = {})
      validate_options(options)
      @current_user = options[:current_user]
      @seller = seller_based_on(@current_user)
      @order_hash = options[:order_hash]
      @gold_batch_hash = options[:gold_batch_hash]
      @remote_address = options[:remote_address]
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
        register_sold_batches(sale_order, selected_gold_batches)
        pdf_generation_service = ::PdfGeneration.new
        response = pdf_generation_service.call(
          order: sale_order,
          # signature_picture: signature_picture
          draw_pdf_service: ::Sale::ProofOfSale::DrawPDF,
          document_type: 'equivalent_document' # TODO: invoice here
        )
        sale_order.published!
        # NOTE: the next process will be generated in a background job
        worker_id = GeneratePdfWorker.perform_async(sale_order.id)
      end
      response
    end

    # Creates a basic sale order with the correct values
    # @return [ Order ]
    def setup_sale_order!
      order_hash.merge!(type: 'sale')
      @sale_order = seller.sales.build(order_hash)
      @sale_order.build_gold_batch(gold_batch_hash.deep_symbolize_keys)
      response[:success] = Order.audit_as(seller) { @sale_order.save_with_sequence(@current_user) } # This save both the new sale and gold_batch
      @sale_order.update_remote_address!(remote_address)
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