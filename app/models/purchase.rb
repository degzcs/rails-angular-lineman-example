# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  provider_id                 :integer
#  origin_certificate_sequence :string(255)
#  gold_batch_id               :integer
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#  seller_picture              :string(255)
#

require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/html_outputter'
#TODO: extract origin_certicated* fields to a single table and make the association
class Purchase < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :user
  # belongs_to :provider
  belongs_to :gold_batch
  has_one :inventory

  #
  # Callbacks
  #
  after_create :create_inventory
  before_save :generate_barcode

  #
  # Fields
  #
  mount_uploader :origin_certificate_file, AttachmentUploader
  mount_uploader :seller_picture, AttachmentUploader

  # This is the uniq code assigned to this purchase
  def reference_code
    Digest::MD5.hexdigest "#{origin_certificate_sequence}#{id}"
  end

  #Gets the provider of the purchase
  # IMPROVE: I think this is an association like "belongs_to :provider" and in the provider model "has_many :purchases"
  def provider
    Provider.find(self.provider_id)
  end

  # @return [Barby::HtmlOutputter] wiht the purchase code converted in a barcode
  def barcode_html
    barcode = Barby::EAN13.new(self.code)
    Barby::HtmlOutputter.new(barcode).to_html
  end

  protected
    #After create the purchase it creates its own inventory with the remaining_amount value equals to the gold batch amount buyed
    def create_inventory
      Inventory.create(purchase_id: self.id, remaining_amount: self.gold_batch.grams)
    end

    # Article about how setup ean13
    # http://www.barcodeisland.com/ean13.phtml
    def generate_barcode
      # Number System: 3 digits
      # this is Colombia code:
      number_system = "770"

      # Manufacturer Code: 5 digits
      # this is the office code:
      mfg_code =  self.user.id.to_s.rjust(5, '0') #TODO: user.officce.reference_code

      # Product Code: 4 digits
      # This is the goldbach code:
      product_code= self.gold_batch_id.to_s.rjust(4, '0') #TODO: self.gold_batch.reference_code

      # Check Digit: 1 digit
      # this is calculated by Barby (gem)
      code = "#{number_system}#{mfg_code}#{product_code}"
      self.code = code
    end

end
