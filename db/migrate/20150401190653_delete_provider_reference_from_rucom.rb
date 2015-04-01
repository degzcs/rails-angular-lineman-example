class DeleteProviderReferenceFromRucom < ActiveRecord::Migration
  def change
    remove_column :rucoms, :provider_id
    add_column :providers, :rucom_id, :integer
  end
end
