class AddLastTransactionSequenceToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :last_transaction_sequence, :integer, default: 0
  end
end
