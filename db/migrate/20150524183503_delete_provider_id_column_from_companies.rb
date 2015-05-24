class DeleteProviderIdColumnFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :provider_id, :integer
  end
end
