# == Schema Information
#
# Table name: transaction_movements
#
#  id             :integer          not null, primary key
#  puc_account_id :integer
#  type           :string(255)
#  block_name     :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  afectation     :string(255)
#

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
  validates :accounting_entry, presence: true

  TYPES = {
    sale: 'Venta',
    purchase: 'Compra'
  }.freeze

  ACCOUNTING_ENTRIES = {
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

  def self.accounting_entries_for_select
    ACCOUNTING_ENTRIES.collect { |val| [val[1], val[0]] }
  end

  def self.block_names_for_select
    BLOCK_NAMES.collect { |val| [val[1], val[0]] }
  end
end
