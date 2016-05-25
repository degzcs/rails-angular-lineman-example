# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  unit                :integer
#  per_unit_value      :float
#  payment_flag        :boolean          default(FALSE)
#  payment_date        :datetime
#  discount_percentage :float            default(0.0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  total_amount        :float            default(0.0), not null
#  discount            :float            default(0.0), not null
#

# TODO: change unit field name to amount or similar.
# TODO: change paymment_flag field name to paid, which is more clear.
class CreditBilling < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :user

  #
  # Callbacks
  #
  before_save :calculate_total
  after_initialize :init

  #
  # Validations
  #

  # TODO: validates if the user is a legal representative, who is the one that can buy these credits. No one can buy them!!
  validates :user_id, presence: true
  validates :unit, presence: true
  validates :per_unit_value, presence: true
  validates :discount_percentage, presence: { message: "El porcentaje de descuento debe ser un valor entre 0 y 100" },  :inclusion => 0..100

  #
  # => Instance methods
  #

  def iva_value
    self.total_amount * 0.16
  end

  #
  # => Protected methods
  #

  protected

    # Initialize values when a new credit_billing is build
    def init
      self.per_unit_value = 500
    end

    # Before save a new credit_billing calculate the discount and the total
    def calculate_total
      subtotal = self.unit * self.per_unit_value
      discount = subtotal * self.discount_percentage/100
      self.discount = discount
      self.total_amount = subtotal - discount
    end
end
