class RemoveUserIdAndProviderIdFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :user_id, :integer
    remove_column :purchases, :provider_id, :integer
  end
end
