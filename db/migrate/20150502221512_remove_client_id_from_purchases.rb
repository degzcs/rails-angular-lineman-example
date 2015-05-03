class RemoveClientIdFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :client_id, :string
  end
end
