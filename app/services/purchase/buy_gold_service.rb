# There are almost  two types of purchases
# 1. when the current user (buyer) buy gold from provider who is no active member in the trazoro plataform
# the provider types under this category are: "chatarrero" y "barequero"
# 2. when the current user (buyer) buy gold from provider who is  an active user in the plataform
# the provider types under this category are: ""
#
module Purchase
  # Service BuyGoldService
  class BuyGoldService
    attr_accessor :buyer
    attr_accessor :seller
    attr_accessor :purchase_order
    attr_accessor :order_hash
    attr_accessor :gold_batch_hash
    attr_accessor :response
    attr_accessor :performer_user

    #
    # @params order_hash  [Hash]
    # @params bold_batch_hash  [Hash]
    # @params buyer [User]
    # @params seller [User]
    #
    def initialize
      @response = {}
      @response[:errors] = []
    end

    # @return [ Hash ] with the success or errors
    def call(options = {})
      validate_sent_options(options)
      # seller is the gold provider
      @performer_user = options[:current_user]
      @buyer = buyer_from(options[:current_user])
      @order_hash = options[:order_hash]
      @gold_batch_hash = options[:gold_batch_hash]
      @date = options[:date]
      @signature_picture = @order_hash.delete('signature_picture')
      buy!
    end

    def validate_sent_options(options)
      raise 'You must to provide a current_user option' if options[:current_user].blank?
      raise 'You must to provide a order_hash option' if options[:order_hash].blank?
      raise 'You must to provide a gold_batch_hash option' if options[:gold_batch_hash].blank?
      raise 'You must to provide a date option' if options[:date].blank?
    end

    #
    # @return [ Hash ] with the success or errors
    # TODO: define is the purchase will be done as a natural person or as a Copany
    # This will define the rucom and city to be used and the dicount credits to the correct
    # user as well.
    def buy!
      # Build purchase
      if can_buy?(buyer, @order_hash['seller_id'], gold_batch_hash['fine_grams'])
        ActiveRecord::Base.transaction do
          @purchase_order = set_attributes_purchase!
          discount_credits_to!(buyer, gold_batch_hash['fine_grams']) unless @purchase_order.trazoro
          pdf_generation_service = ::Purchase::PdfGeneration.new
          klass_pdf = ::Purchase::ProofOfPurchase::DrawPDF
          response = pdf_generation_service.call(attrs_to_pdf(@purchase_order, @signature_picture, 'equivalent_document', klass_pdf))
          klass_pdf = ::OriginCertificates::DrawAuthorizedProviderOriginCertificate
          response = pdf_generation_service.call(attrs_to_pdf(@purchase_order, @signature_picture, 'origin_certificate', klass_pdf, @date))
        end
      end
      response
    end

    def attrs_to_pdf(purchase, sg_picture, doc_type, klass_pdf, date = nil)
      {
        purchase_order: purchase,
        signature_picture: sg_picture,
        document_type: doc_type,
        draw_pdf_service: klass_pdf,
        date: date
      }
    end

    def set_attributes_purchase!
      @purchase_order = buyer.purchases.build(order_hash.merge(type: 'purchase'))
      @purchase_order.build_gold_batch(gold_batch_hash.deep_symbolize_keys)
      @purchase_order.performer = @performer_user
      @response[:success] = @purchase_order.save!
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

    # @return [ Boolean ]
    def can_buy?(buyer, seller_id, buyed_fine_grams)
      user_can_buy?(buyer, buyed_fine_grams) &&
        under_monthly_thershold?(seller_id, buyed_fine_grams)
    end

    # @param buyer [ User ]
    # @param buyed_fine_grams [ String ]
    # @return [ Boolean ]
    def user_can_buy?(buyer, buyed_fine_grams)
      response[:success] = buyer.available_credits >= buyed_fine_grams.to_f # TODO: change to price
      response[:errors] << 'No tienes los suficientes creditos para hacer esta compra' unless response[:success]
      response[:success]
    end

    # @param seller_id [ String ]
    # @param buyed_fine_grams [ String ]
    # @return [ Boolean ]
    def under_monthly_thershold?(seller_id, buyed_fine_grams)
      already_buyed_gold = Order.fine_grams_sum_by_date(Date.today, seller_id)
      response[:success] = ((already_buyed_gold + buyed_fine_grams.to_f) <= Settings.instance.monthly_threshold.to_f)
      seller_name = UserPresenter.new(User.find(seller_id), self).name unless response[:success]
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
  end
end
