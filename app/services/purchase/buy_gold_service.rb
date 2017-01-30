# There are almost  two types of purchases
# 1. when the current user (buyer) buy gold from provider who is no active member in the trazoro plataform
# the provider types under this category are: "chatarrero" y "barequero"
# 2. when the current user (buyer) buy gold from provider who is  an active user in the plataform
# the provider types under this category are: ""
#
module Purchase
  # Service BuyGoldService
  class BuyGoldService
    attr_reader :buyer, :seller, :purchase_order, :order_hash, :gold_batch_hash, :performer_user, :signature_picture, :date,
                :current_user, :remote_address
    attr_accessor :response

    def initialize
      @response = {}
      @response[:errors] = []
      @settings ||= Settings.instance
    end

    #
    # @params order_hash  [Hash]
    # @params bold_batch_hash  [Hash]
    # @params buyer [User]
    # @params seller [User]
    # @return [ Hash ] with the success or errors
    def call(options = {})
      validate_options(options)
      # seller is the gold provider
      @seller = User.find(options[:order_hash]['seller_id'])
      @current_user = options[:current_user]
      @buyer = buyer_from(@current_user)
      @order_hash = options[:order_hash]
      @gold_batch_hash = options[:gold_batch_hash]
      @remote_address = options[:remote_address]
      @date = options[:date]
      @signature_picture = @order_hash.delete('signature_picture')
      buy!
    end

    private

    # @return [ Hash ] with the success or errors
    # TODO: define is the purchase will be done as a natural person or as a Copany
    # This will define the rucom and city to be used and the dicount credits to the correct
    # user as well.
    def buy!
      if can_buy?(seller, gold_batch_hash['fine_grams'])
        ActiveRecord::Base.transaction do
          discount_credits_service = ::DiscountCredits.new
          discount_credits_service.call(
            buyer: buyer,
            buyed_fine_grams: gold_batch_hash['fine_grams']
          )
          purchase_order = setup_purchase_order!
          pdf_generation_service = ::PdfGeneration.new
          response = pdf_generation_service.call(
                       order: purchase_order,
                       signature_picture: signature_picture,
                       draw_pdf_service: ::Purchase::ProofOfPurchase::DrawPDF,
                       document_type: 'equivalent_document'
                     )

          response = pdf_generation_service.call(
                       order: purchase_order,
                       signature_picture: signature_picture,
                       draw_pdf_service: ::OriginCertificates::DrawAuthorizedProviderOriginCertificate,
                       document_type: 'origin_certificate',
                       date: date
                     )
          if purchase_order.price > @settings.data[:ros_threshold].to_i
            response = pdf_generation_service.call(
              order: purchase_order,
              draw_pdf_service: ::UiafReport::DrawUiafReport,
              document_type: 'uiaf_report'
            )
          end
          response
        end
      end
    rescue StandardError => e
      response[:errors] << e.message
      response[:success] = false
      response
    end

    # Creates a basic purchase order with the correct values
    # @return [ Order ]
    def setup_purchase_order!
      order_hash.merge!(type: 'purchase')
      @purchase_order = buyer.purchases.build(order_hash)
      @purchase_order.build_gold_batch(gold_batch_hash.deep_symbolize_keys)
      @purchase_order.end_transaction!(current_user)
      response[:success] = Order.audit_as(current_user) { @purchase_order.save! }
      @purchase_order.update_remote_address!(remote_address)
      @purchase_order
    end

    # Decides if the current user is who will be buyer or if it is just a worker for a company.
    # @param current_user [ User ]
    # @retrurn [ User ]
    def buyer_from(current_user)
      if current_user.has_office?
        current_user.office.company.legal_representative
      else
        current_user
      end
    end

    # @params buyer [ User ]
    # @params seller [ User ]
    # @param buyed_fine_grams [ String ]
    # @return [ Boolean ]
    def can_buy?(seller, buyed_fine_grams)
      under_monthly_thershold?(seller, buyed_fine_grams)
    end

    # @param seller [ User ]
    # @param buyed_fine_grams [ String ]
    # @return [ Boolean ]
    def under_monthly_thershold?(seller, buyed_fine_grams)
      already_buyed_mineral = Order.fine_grams_sum_by_date(Time.now, seller.id, gold_batch_hash['mineral_type'])
      response[:success] = ((already_buyed_mineral + buyed_fine_grams.to_f) <= @settings.data[:monthly_threshold].to_f)
      seller_name = UserPresenter.new(seller, self).name unless response[:success]
      raise error_message(seller_name, already_buyed_mineral) unless response[:success]
      response[:success]
    end

    def error_message(seller_name, already_buyed_mineral)
      'Usted no puede realizar esta compra, debido a que con esta compra el barequero '\
      'exederia el limite permitido por mes. El total comprado hasta el momento por '\
      "#{seller_name} es: #{already_buyed_mineral} gramos finos"
    end

    # Validates the params passed to this service
    # @param options [ Hash ]
    def validate_options(options)
      raise 'You must to provide a current_user option' if options[:current_user].blank?
      raise 'You must to provide a order_hash option' if options[:order_hash].blank?
      raise 'You must to provide a gold_batch_hash option' if options[:gold_batch_hash].blank?
      raise 'You must to provide a date option' if options[:date].blank?
    end
  end
end
