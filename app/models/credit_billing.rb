# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  payment_date        :datetime
#  discount_percentage :float            default(0.0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  total_amount        :float            default(0.0), not null
#  discount            :float            default(0.0), not null
#  paid                :boolean          default(FALSE)
#  quantity            :float
#  unit_price          :float
#  invoiced            :boolean          default(FALSE)
#  alegra_id           :integer
#

class CreditBilling < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :user
  after_initialize :init

  #
  # Callbacks
  #

  before_save :calculate_total

  #
  # Validations
  #

  validates :user_id, presence: true
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :discount_percentage, presence: { message: "El porcentaje de descuento debe ser un valor entre 0 y 100" },  :inclusion => 0..100
  before_validation :can_buy?

  #
  # Instance methods
  #

  def init
    self..discount = 0.0
    self.unit_price = Settings.instance.fine_gram_value
  end

  def vat
    self.total_amount * Settings.instance.vat_percentage.to_f/100
  end

  protected

  # Only the user who are legal representative or those user that buy gold as a natural
  # person can buy credits. Those users who are working for a company and buy with the
  # company rucom, they cannot buy credits.
  def can_buy?
    if self.user && !self.user.legal_representative && self.user.has_office?
      self.errors.add :user, 'Este usuario no esta autorizado para comprar creditos'
    end
  end

  # Before save a new credit_billing calculate the discount and the total
  def calculate_total
    subtotal = self.quantity * self.unit_price
    discount = subtotal * self.discount_percentage/100
    self.discount = discount
    self.total_amount = subtotal - discount
  end
end
