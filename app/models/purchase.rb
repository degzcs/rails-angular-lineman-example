# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  origin_certificate_sequence :string(255)
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#  seller_picture              :string(255)
#  code                        :text
#  trazoro                     :boolean          default(FALSE), not null
#  seller_id                   :integer
#  inventory_id                :integer
#

require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/html_outputter'
# TODO: extract origin_certicated* fields to a single table and make the association
# TODO: the origin_certificate_files in a trazoro transaction will be the collection of the old purchase files so this name has to be changed to something similar to 'mineral_documentation'
class Purchase < ActiveRecord::Base
  #
  # Associations
  #

  has_one :user, through: :inventory # TODO: change name to buyer.
  belongs_to :seller, class_name: "User"

  has_one :gold_batch, class_name: "GoldBatch", as: :goldomable
  belongs_to :inventory
  has_many :sold_batches, dependent: :destroy
  has_many :documents, class_name: "Document", as: :documentable, dependent: :destroy

  # NOTE: this name is the most close to the real meaning of this field, because it is not always an invoice, most of the time it will be a equivalent-document.

  #
  # Validations
  #

  validates :inventory_id, presence: true
  validates :seller_id, presence: true
  #validates :origin_certificate_sequence, presence: true
  # validates :gold_batch_id, presence: true
  validates :origin_certificate_file, presence: true
  validates :price, presence: true

  accepts_nested_attributes_for :gold_batch

  #
  # Callbacks
  #


  before_save :generate_barcode
  after_create :update_inventory_amount

  #
  # Fields
  #

  # TODO: change this mount uplaod for
  # def origin_certicate_file
  #   documents.where(type: 'origin_certificate_file').first
  # end
  mount_uploader :origin_certificate_file, DocumentUploader
  mount_uploader :seller_picture, PhotoUploader

  #
  # Instance methods
  #

  # For now it is selcting the equivalente document.
  # TODO: upgrade to select the correct invoice or equivalent document
  def proof_of_purchase
    documents.where(type: 'equivalent_document').first
  end

  # This is the unique code assigned to this purchase
  def reference_code
    Digest::MD5.hexdigest "#{origin_certificate_sequence}#{id}"
  end

  # @return [Barby::HtmlOutputter] wiht the purchase code converted in a barcode
  def barcode_html
    barcode = Barby::EAN13.new(self.code)
    Barby::HtmlOutputter.new(barcode).to_html
  end

  #
  # Class methods
  #

  #Get a list of purchases using an array of puchase ids
  def self.get_list(ids_array)
    list = []
    ids_array.each do |id|
      purchase = Purchase.find(id)
      list << purchase
    end
    list
  end

  #
  # Protected methods
  #

  protected

  # TODO: to improve this method make a touch method that trigger the inventory and
  # re-calculate the correct amount based on the gold batches that have not been sold yet
  def update_inventory_amount
    self.inventory.update_attributes(remaining_amount: self.gold_batch.fine_grams)
  end

  # Article about how setup ean13
  # http://www.barcodeisland.com/ean13.phtml
  def generate_barcode
    # Number System: 3 digits
    # this is Colombia code:
    number_system = "770"

    # Manufacturer Code: 5 digits
    # this is the office code:
    mfg_code =  self.seller.id.to_s.rjust(5, '0') #TODO: seller.officce.reference_code

    # Product Code: 4 digits
    # This is the goldbach code:
    product_code= self.gold_batch.id.to_s.rjust(4, '0') #TODO: self.gold_batch.reference_code

    # Check Digit: 1 digit
    # this is calculated by Barby (gem)
    code = "#{number_system}#{mfg_code}#{product_code}"
    self.code = code
  end

end
