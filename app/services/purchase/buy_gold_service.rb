# There are almost  two types of purchases
# 1. when the current user (buyer) buy gold from provider who is no active member in the trazoro plataform
# the provider types under this category are: "chatarrero" y "barequero"
# 2. when the current user (buyer) buy gold from provider who is  an active user in the plataform
# the provider types under this category are: ""
#
module Purchase
  # Service BuyGoldService
  class BuyGoldService
    attr_reader :buyer, :seller, :purchase_order, :order_hash, :gold_batch_hash, :performer_user, :signature_picture, :date
    attr_accessor :response

    def initialize
      @response = {}
      @response[:errors] = []
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
      @buyer = buyer_from(options[:current_user])
      @order_hash = options[:order_hash]
      @gold_batch_hash = options[:gold_batch_hash]
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
      if can_buy?(buyer, seller, gold_batch_hash['fine_grams'])
        ActiveRecord::Base.transaction do
          purchase_order = setup_purchase_order!
          discount_credits_to!(buyer, gold_batch_hash['fine_grams']) unless purchase_order.trazoro
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
        end
      end
      response
    end

    # Creates a basic purchase order with the correct values
    # @return [ Order ]
    def setup_purchase_order!
      order_hash.merge!(type: 'purchase')
      @purchase_order = buyer.purchases.build(order_hash)
     
      @purchase_order.build_gold_batch(gold_batch_hash.deep_symbolize_keys)
      @purchase_order.end_transaction!
      response[:success] = Order.audit_as(buyer) { @purchase_order.save! }
      
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
    def can_buy?(buyer, seller, buyed_fine_grams)
      user_can_buy?(buyer, buyed_fine_grams) &&
        under_monthly_thershold?(seller, buyed_fine_grams)
    end

    # @param buyer [ User ]
    # @param buyed_fine_grams [ String ]
    # @return [ Boolean ]
    def user_can_buy?(buyer, buyed_fine_grams)
      response[:success] = buyer.available_credits >= buyed_fine_grams.to_f # TODO: change to price
      response[:errors] << 'No tienes los suficientes creditos para hacer esta compra' unless response[:success]
      response[:success]
    end

    # @param seller [ User ]
    # @param buyed_fine_grams [ String ]
    # @return [ Boolean ]
    def under_monthly_thershold?(seller, buyed_fine_grams)
      already_buyed_gold = Order.fine_grams_sum_by_date(Time.now, seller.id)
      response[:success] = ((already_buyed_gold + buyed_fine_grams.to_f) <= Settings.instance.monthly_threshold.to_f)
      seller_name = UserPresenter.new(seller, self).name unless response[:success]
      response[:errors] << error_message(seller_name, already_buyed_gold) unless response[:success]
      response[:success]
    end

    def error_message(seller_name, already_buyed_gold)
      'Usted no puede realizar esta compra, debido a que con esta compra el barequero '\
      'exederia el limite permitido por mes. El total comprado hasta el momento por '\
      "#{seller_name} es: #{already_buyed_gold} gramos finos"
    end

    # def company_can_buy?(buyer, buyed_fine_grams)
    #   buyer.company.available_credits >= buyed_fine_grams.to_f
    # end
    def discount_credits_to!(buyer, buyed_fine_grams)
      new_credits = buyer.available_credits - buyed_fine_grams.to_f
      buyer.profile.update_column(:available_credits, new_credits)
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
