# == Schema Information
#
# Table name: sales
#
#  id            :integer          not null, primary key
#  courier_id    :integer
#  client_id     :integer
#  user_id       :integer
#  gold_batch_id :integer
#  code          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  price         :float
#  trazoro       :boolean          default(FALSE), not null
#

require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/html_outputter'

class Sale < ActiveRecord::Base

  #
  # Associations
  #

  belongs_to :user
  belongs_to :client, class_name: "User"

  belongs_to :courier
  has_many :batches , class_name: "SoldBatch" #=> The model is SoldBatch but for legibility purpouses is renamed to batch (batches*)
  belongs_to :gold_batch
  has_many :documents, class_name: "Document", as: :documentable

  #
  # Callbacks
  #

  before_save :generate_barcode

  #
  # Uploaders
  #

  #
  # Validations
  #

  validates :courier_id, presence: true
  validates :client_id, presence: true
  validates :user_id, presence: true

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
    (price/fine_grams)
  end

  protected

  #Before the sale is saved generate a barcode and its html representation
  def generate_barcode
    # new_id = Sale.count + 1
    # code = new_id.to_s.rjust(12, '0')
    # self.code = code

    # Number System: 3 digits
    # this is Colombia code:
    number_system = "770"

    # Manufacturer Code: 5 digits
    # this is the office code:
    mfg_code =  self.client_id.to_s.rjust(5, '0') #TODO: user.officce.reference_code
                                                  # In puchases mfg_code uses the user id. Using client_id in sales for
                                                  # ensuring uniqueness (?)

    # Product Code: 4 digits
    # This is the goldbach code:
    product_code= self.gold_batch_id.to_s.rjust(4, '0') #TODO: self.gold_batch.reference_code
                                                        # (!) This doesn't guarantee the product code to be unique once
                                                        # the gold_batch id sequence reaches the 9999 value, does it?

    # Check Digit: 1 digit
    # this is calculated by Barby (gem)
    code = "#{number_system}#{mfg_code}#{product_code}"
    self.code = code
  end
end
