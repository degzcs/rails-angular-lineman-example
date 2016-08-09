class RemoveColumnsFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :city, :string
    remove_column :companies, :state, :string
    remove_column :companies, :country, :string
  end
end
