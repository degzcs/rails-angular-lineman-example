# == Schema Information
#
# Table name: sales
#
#  id                      :integer          not null, primary key
#  courier_id              :integer
#  client_id               :integer
#  user_id                 :integer
#  gold_batch_id           :integer
#  code                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  origin_certificate_file :string(255)
#  price                   :float
#

#TODO: change field name from grams to fine_grams
# however I think the grams or fine_grams is a delegate method like I do with grade
require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/html_outputter'

class Sale < ActiveRecord::Base
  #
  # Associations
  #
  has_many :batches , class_name: "SoldBatch" #=> The model is SoldBatch but for legibility purpouses is renamed to batch (batches*)
  belongs_to :user
  belongs_to :gold_batch
  #
  # Callbacks
  #
  before_save :generate_barcode

  #
  # Uploaders
  #
  mount_uploader :origin_certificate_file, AttachmentUploader

  #
  # Validations
  #
  validates :courier_id, presence: true
  validates :client_id, presence: true
  validates :user_id, presence: true

  def barcode_html
    barcode = Barby::EAN13.new(self.code)
    barcode_html = Barby::HtmlOutputter.new(barcode).to_html
  end

  def grams
    gold_batch.grams
  end

  def grade
    gold_batch.grade
  end

  def fine_gram_unit_price
    (price/grams)
  end

  protected
    #Before the sale is saved generate a barcode and its html representation
    def generate_barcode
      new_id = Sale.count + 1
      code = new_id.to_s.rjust(12, '0')
      self.code = code
    end
end
