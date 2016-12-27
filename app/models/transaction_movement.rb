# TransactionMovement class allows to list the puc_accounts by block names group
class TransactionMovement < ActiveRecord::Base
  belongs_to :puc_account

  #
  # STI config
  #
  self.inheritance_column = 'sti_type'

  validates :puc_account_id, presence: true
  validates :type, presence: true
  validates :block_name, presence: true
  validates :afectation, presence: true

  TYPES = {
    sale: 'Venta',
    purchase: 'Compra'
  }.freeze

  AFECTATIONS = {
    D: 'Débito',
    C: 'Crédito'
  }.freeze

  BLOCK_NAMES = {
    movements: 'Movimientos',
    taxes: 'Impuestos',
    inventories: 'Inventarios',
    payments: 'Pagos'
  }

  def self.types_for_select
    TYPES.collect { |val| [val[1], val[0]] }
  end

  def self.afectations_for_select
    AFECTATIONS.collect { |val| [val[1], val[0]] }
  end

  def self.block_names_for_select
    BLOCK_NAMES.collect { |val| [val[1], val[0]] }
  end
end
