class RemoveFieldsFromPucAccounts < ActiveRecord::Migration
  def change
    remove_column :puc_accounts, :debit, :string
    remove_column :puc_accounts, :credit, :string
    remove_column :puc_accounts, :account_nature, :string
  end
end
