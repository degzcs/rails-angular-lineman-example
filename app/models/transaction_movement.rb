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
end
