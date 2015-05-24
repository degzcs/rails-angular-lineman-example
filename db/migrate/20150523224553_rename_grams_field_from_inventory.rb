class RenameGramsFieldFromInventory < ActiveRecord::Migration
  def change
    rename_column :gold_batches, :grams, :fine_grams
    remove_column :gold_batches, :parent_batches , :string
  end
end
