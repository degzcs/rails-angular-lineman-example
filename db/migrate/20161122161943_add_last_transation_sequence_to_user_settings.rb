class AddLastTransationSequenceToUserSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :last_transaction_sequence, :integer, default: 0
  end
end
