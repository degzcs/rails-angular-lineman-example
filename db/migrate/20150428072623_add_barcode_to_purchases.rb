class AddBarcodeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :code, :text
  end
end
