# == Schema Information
#
# Table name: orders
#
#  id                   :integer          not null, primary key
#  buyer_id             :integer
#  seller_id            :integer
#  courier_id           :integer
#  type                 :string(255)
#  code                 :string(255)
#  price                :float
#  seller_picture       :string(255)
#  trazoro              :boolean          default(FALSE), not null
#  created_at           :datetime
#  updated_at           :datetime
#  transaction_state    :string(255)
#  alegra_id            :integer
#  invoiced             :boolean          default(FALSE)
#  payment_date         :datetime
#  transaction_sequence :integer
#

require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/html_outputter'
# TODO create a state machine to handle the order stauts
class Order < ActiveRecord::Base
  #
  # STI config
  #

  self.inheritance_column = 'sti_type'

  #
  # Associations
  #

  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  belongs_to :courier
  has_one :gold_batch, class_name: "GoldBatch", as: :goldomable # TODO: remove polymophims it is deprecated, use a regular rails asssociation instead.
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy
  has_many :batches, class_name: 'SoldBatch' #=> The model is SoldBatch but for legibility purpouses is renamed to batch (batches*)

  audited associated_with: :buyer
  audited associated_with: :seller
  #
  # Validations
  #

  #
  # Callbacks
  #

  before_save :generate_barcode
  before_save :persist_status

  #
  # Uploaders
  #

  mount_uploader :seller_picture, PhotoUploader

  #
  # Scopes
  #

  scope :fine_grams_sum_by_date, ->(date, seller_id) { where(created_at: (date.beginning_of_month.beginning_of_day .. date.end_of_month.end_of_day)).where(seller_id: seller_id).joins(:gold_batch).sum('gold_batches.fine_grams') }
  scope :remaining_amount_for, ->(buyer) { where(buyer_id: buyer.id).joins(:gold_batch).where('gold_batches.sold IS NOT true').sum('gold_batches.fine_grams') }
  scope :purchases, ->(ids) { where(type: 'purchase', id: ids) }
  scope :purchases_free, ->(buyer) { where(type: 'purchase', buyer: buyer).includes(:gold_batch).where(gold_batches: { sold: false }) }
  scope :sales_by_state_as_buyer, ->(buyer, state) { where(type: 'sale', buyer: buyer, transaction_state: state) }
  scope :sales_by_state_as_seller, ->(seller, state) { where(type: 'sale', seller: seller, transaction_state: state) }
  #
  # State Machine for transaction_state field
  #
  include StateMachines::OrderStates

  #
  # Instance Methods
  #

  # NOTE: temporal method to avoid break the app. It must to be removed asap.
  def origin_certificate_file
    self.origin_certificate.file
  end

  def origin_certificate
    documents.where(type: 'origin_certificate').first
  end

  # It is the collection of all origin certificates, buyer IDs,
  # equivalente documents or invoices, barequero Id or miner register documents.
  # @return [ Document ]
  def purchase_files_collection
    documents.where(type: 'purchase_files_collection').first
  end

  # The #proof_of_purchase and #proof_of_sale have to be set up as invoices and their names should be more specific to avoid
  # issues when this order has more than one invoice (if it is possible)
  # Check the next  possibilities to know the correct name in each case:
  # - Buy to authorized provider (Barequero, chatarrero)
  # - Buy to another trader (Jeweler, Local trader, CI, exporter)
  # For now it is selcting the equivalente document.
  # TODO: upgrade to select the correct invoice or equivalent document
  def proof_of_purchase
    documents.where(type: 'equivalent_document').first
  end

  # TODO: This document has to change to invoice, and not equivalente document anymore.
  # It could be a equivalent_document or invoice, for now it is using the first one only.
  # @return [ Document ]
  def proof_of_sale
    documents.where(type: 'equivalent_document').first
  end

  def purchase_files_collection_with_watermark
    documents.where(type: 'purchase_files_collection_with_watermark').first
  end

  # TODO: Change proof_of_sale and proof_of_purchase because is ambiguous, 
  # in SaleGoldService the document_type should be compendium and the service ProofOfSale should rename to Compendium too
  def compendium
    documents.where(type: 'compendium').first
  end

  #
  # @return [ Document ]
  def shipment
    documents.where(type: 'shipment').first
  end

  def barcode_html
    barcode = Barby::EAN13.new(self.code)
    barcode_html = Barby::HtmlOutputter.new(barcode).to_html
  end

  def fine_grams
    gold_batch.fine_grams
  end

  def grade
    gold_batch.grade
  end

  def fine_gram_unit_price
    (price / fine_grams)
  end

  def purchases_total_value
    self.batches.map{ |b| b.gold_batch.goldomable.price }.sum
  end

  def total_gain
    # (precio final - precio inicial)/cantd de gramos
    (price - purchases_total_value)
  end

  # For now it is selcting the equivalente document.
  # TODO: upgrade to select the correct invoice or equivalent document
  def origin_certificate
    documents.where(type: 'origin_certificate').first
  end
  # This is the unique code assigned to this purchase
  def reference_code
    Digest::MD5.hexdigest "#{origin_certificate_sequence}#{id}"
  end

  # presenter of sold's state
  def gold_state
    gold_batch.sold? ? 'Vendido' : 'Disponible'
  end

  def buyer?(current_user)
    current_user == buyer
  end

  def seller?(current_user)
    current_user == seller
  end

  # Select the correct seller based on he is a natual or legal person.
  # @param current_user [ User ]
  # @return [ User ]
  def legal_representative?(current_user)
      current_user.profile.legal_representative?
  end

  # Generate the sequence to every transaction based on last_transation_sequence from settings
  def save_with_sequence(current_user)
    raise ActiveRecord::RecordInvalid.new(self) unless valid?
    setting = current_user.setting
    setting.with_lock do
      self.with_lock do
        seq = setting.last_transaction_sequence + 1
        self.transaction_sequence = seq
        self.save!
        setting.update_attributes!(last_transaction_sequence: seq)
      end
    end
  end

  # TODO: define the Right format to show the sequence number
  def sequence_number
    sprintf '%05d', transaction_sequence.to_i
  end

  protected

  # Before the sale is saved generate a barcode and its html representation
  def generate_barcode
    # Number System: 3 digits
    # this is Colombia code:
    number_system = "770"

    # Manufacturer Code: 5 digits
    # this is the office code:
    mfg_code = self.seller_id.to_s.rjust(5, '0') #TODO: user.officce.reference_code
                                                  # In puchases mfg_code uses the user id. Using buyer_id in sales for
                                                  # ensuring uniqueness (?)

    # Product Code: 4 digits
    # This is the goldbach code:
    product_code = self.gold_batch.id.to_s.rjust(4, '0') #TODO: self.gold_batch.reference_code
                                                        # (!) This doesn't guarantee the product code to be unique once
                                                        # the gold_batch id sequence reaches the 9999 value, does it?

    # Check Digit: 1 digit
    # this is calculated by Barby (gem)
    code = "#{ number_system }#{ mfg_code }#{ product_code }"
    self.code = code
  end
end
