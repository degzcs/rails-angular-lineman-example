class RemoveProviderTypeFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :provider_type, :string
  end
end
