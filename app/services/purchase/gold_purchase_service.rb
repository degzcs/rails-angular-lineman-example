# There are almost  two types of purchases
# 1. when the current user (buyer) buy gold from provider who is no active member in the trazoro plataform
# the provider types under this category are: "chatarrero" y "barequero"
# 2. when the current user (buyer) buy gold from provider who is  an active user in the plataform
# the provider types under this category are: ""
#
class Purchase::GoldPurchaseService
  attr_accessor :buyer
  attr_accessor :seller
  attr_accessor :purchase
  attr_accessor :purchase_hash
  attr_accessor :gold_batch_hash

  #
  # @params purchase_hash  [Hash]
  # @params bold_batch_hash  [Hash]
  # @params buyer [User]
  # @params seller [User]
  #
  def initialize
  end

  # @return [ Hash ] with the success or errors
  def call(options={})
    raise 'You must to provide a buyer option' if options[:buyer].blank?
    raise 'You must to provide a purchase_hash option' if options[:purchase_hash].blank?
    raise 'You must to provide a gold_batch_hash option' if options[:gold_batch_hash].blank?
    # seller is the gold provider
    @buyer = options[:buyer]
    @purchase_hash = options[:purchase_hash]
    @gold_batch_hash = options[:gold_batch_hash]
    buy!
  end

  #
  # @return [ Hash ] with the success or errors
  # TODO: define is the purchase will be done as a individual-persona or as a Copany
  # This will define the rucom and city to be used and the dicount credits to the correct
  # user as well.
  def buy!
   # Build purchase
    response = {}

    if can_buy?(buyer, gold_batch_hash['fine_grams'])
      ActiveRecord::Base.transaction do
        gold_batch = GoldBatch.new(gold_batch_hash.deep_symbolize_keys)
        gold_batch.save!
        @purchase = buyer.purchases.build(purchase_hash.merge(gold_batch_id: gold_batch.id))
        response[:success] = @purchase.save!
        response[:errors] = @purchase.errors.full_messages
        discount_credits_to!(buyer, gold_batch_hash['fine_grams']) unless purchase.trazoro
        response = ::Purchase::ProofOfPurchaseGeneration.new.call(purchase: purchase) if response[:success]
      end
    else
      false
    end
    response
  end

  def can_buy?(buyer, buyed_fine_grams)
    buyer.available_credits >= buyed_fine_grams.to_f # TODO: change to price
  end

  def discount_credits_to!(buyer, buyed_fine_grams)
    new_credits = buyer.available_credits - buyed_fine_grams.to_f
    buyer.update_column(:available_credits, new_credits)
  end
end