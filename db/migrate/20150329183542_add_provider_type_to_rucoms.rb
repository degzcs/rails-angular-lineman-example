class AddProviderTypeToRucoms < ActiveRecord::Migration
  def change
    add_column :rucoms, :provider_type, :string
  end
end
