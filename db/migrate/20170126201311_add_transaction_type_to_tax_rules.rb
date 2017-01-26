class AddTransactionTypeToTaxRules < ActiveRecord::Migration
  def change
    add_column :tax_rules, :transaction_type, :string
  end
end
