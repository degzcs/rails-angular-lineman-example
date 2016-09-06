# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  buyer_id       :integer
#  seller_id      :integer
#  courier_id     :integer
#  type           :string(255)
#  code           :string(255)
#  price          :string(255)
#  seller_picture :string(255)
#  trazoro        :boolean          default(FALSE), not null
#  boolean        :boolean          default(FALSE), not null
#  created_at     :datetime
#  updated_at     :datetime
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
  has_one :gold_batch, class_name: "GoldBatch", as: :goldomable
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy
  has_many :batches, class_name: 'SoldBatch' #=> The model is SoldBatch but for legibility purpouses is renamed to batch (batches*)

  #
  # Callbacks
  #

  before_save :generate_barcode

  #
  # Uploaders
  #

  mount_uploader :seller_picture, PhotoUploader


  #
  # Scopes
  #

  scope :fine_grams_sum_by_date, ->(date, seller_id) { where(created_at: (date.beginning_of_month .. date.end_of_month)).where(seller_id: seller_id).joins(:gold_batch).sum('gold_batches.fine_grams') }
  scope :remaining_amount_for, ->(buyer) { where(buyer_id: buyer.id).joins(:gold_batch).where('gold_batches.sold IS NOT true').sum('gold_batches.fine_grams') }

  #
  # Instance Methods
  #

  # NOTE: temporal method to avoid   break the app. It must to be removed asap.
  def origin_certificate_file
    self.purchase_files_collection.file
  end

  # It is the collection of all origin certificates, buyer IDs,
  # equivalente documents or invoices, barequero Id or miner register documents.
  # @return [ Document ]
  def purchase_files_collection
    documents.where(type: 'purchase_files_collection').first
  end

  # For now it is selcting the equivalente document.
  # TODO: upgrade to select the correct invoice or equivalent document
  def proof_of_purchase
    documents.where(type: 'equivalent_document').first
  end

  # It could be a equivalent_document or invoice, for now it is using the first one only.
  # @return [ Document ]
  def proof_of_sale
    documents.where(type: 'equivalent_document').first
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
  def state
    gold_batch.sold? ? 'Vendido' : 'Disponible'
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
