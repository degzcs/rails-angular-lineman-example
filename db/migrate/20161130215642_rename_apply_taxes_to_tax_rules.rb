class RenameApplyTaxesToTaxRules < ActiveRecord::Migration
  def change
    rename_table :apply_taxes, :tax_rules
  end
end
