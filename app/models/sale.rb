# == Schema Information
#
# Table name: sales
#
#  id            :integer          not null, primary key
#  courier_id    :integer
#  client_id     :integer
#  user_id       :integer
#  gold_batch_id :integer
#  grams         :float
#  code          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

#TODO: change field name from grams to fine_grams
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
  # Validations
  #
  validates :courier_id, presence: true
  validates :client_id, presence: true
  validates :user_id, presence: true
  validates :grams, presence: true

  def barcode_html
    barcode = Barby::EAN13.new(self.code)
    barcode_html = Barby::HtmlOutputter.new(barcode).to_html
  end

  protected
    #Before the sale is saved generate a barcode and its html representation
    def generate_barcode
      new_id = Sale.count + 1
      code = new_id.to_s.rjust(12, '0')
      self.code = code
    end
end
