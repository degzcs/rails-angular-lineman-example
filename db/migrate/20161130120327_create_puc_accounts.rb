class CreatePucAccounts < ActiveRecord::Migration
  def change
    create_table :puc_accounts do |t|
      t.string :code
      t.string :name
      t.string :debit
      t.string :credit
      t.string :account_nature

      t.timestamps
    end
  end
end
