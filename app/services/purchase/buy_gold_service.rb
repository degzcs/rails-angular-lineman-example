# There are almost  two types of purchases
# 1. when the current user (buyer) buy gold from provider who is no active member in the trazoro plataform
# the provider types under this category are: "chatarrero" y "barequero"
# 2. when the current user (buyer) buy gold from provider who is  an active user in the plataform
# the provider types under this category are: ""
#
class Purchase::BuyGoldService
  attr_accessor :buyer
  attr_accessor :seller
  attr_accessor :purchase
  attr_accessor :purchase_hash
  attr_accessor :gold_batch_hash
  attr_accessor :response

  #
  # @params purchase_hash  [Hash]
  # @params bold_batch_hash  [Hash]
  # @params buyer [User]
  # @params seller [User]
  #
  def initialize
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options={})
    raise 'You must to provide a current_user option' if options[:current_user].blank?
    raise 'You must to provide a purchase_hash option' if options[:purchase_hash].blank?
    raise 'You must to provide a gold_batch_hash option' if options[:gold_batch_hash].blank?
    # seller is the gold provider
    @buyer = buyer_from(options[:current_user])
    @purchase_hash = options[:purchase_hash]
    @gold_batch_hash = options[:gold_batch_hash]
    buy!
  end

  #
  # @return [ Hash ] with the success or errors
  # TODO: define is the purchase will be done as a natural person or as a Copany
  # This will define the rucom and city to be used and the dicount credits to the correct
  # user as well.
  def buy!
   # Build purchase
    if can_buy?(buyer, @purchase_hash['seller_id'], gold_batch_hash['fine_grams'])
      ActiveRecord::Base.transaction do
        @purchase = buyer.inventory.purchases.build(purchase_hash)
        @purchase.build_gold_batch(gold_batch_hash.deep_symbolize_keys)
        @response[:success] = @purchase.save!
        @response[:errors] << @purchase.errors.full_messages
        discount_credits_to!(buyer, gold_batch_hash['fine_grams']) unless purchase.trazoro
        response = ::Purchase::ProofOfPurchase::GenerationService.new.call(purchase: purchase) if @response[:success]
      end
    end
    response
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
       is_under_monthly_thershold?(seller_id, buyed_fine_grams)
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
  def is_under_monthly_thershold?(seller_id, buyed_fine_grams)
    already_buyed_gold = Purchase.fine_grams_sum_by_date(Date.today, seller_id)
    response[:success] = ((already_buyed_gold + buyed_fine_grams.to_f) <= 30)
    response[:errors] << 'usted no puede realizar esta compra debido a que con esta compra ha exedido el limite permitido por mes' unless response[:success]
    response[:success]
  end

  # def company_can_buy?(buyer, buyed_fine_grams)
  #   buyer.company.available_credits >= buyed_fine_grams.to_f
  # end

  def discount_credits_to!(buyer, buyed_fine_grams)
    new_credits = buyer.available_credits - buyed_fine_grams.to_f
    buyer.profile.update_column(:available_credits, new_credits)
  end
end