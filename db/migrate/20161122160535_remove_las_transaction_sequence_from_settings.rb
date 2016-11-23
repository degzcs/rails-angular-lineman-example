class RemoveLasTransactionSequenceFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :last_transaction_sequence, :integer
  end
end
