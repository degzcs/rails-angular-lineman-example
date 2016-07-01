class RemoveFilesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :document_number, :string
    remove_column :users, :document_expedition_date, :string
    remove_column :users, :phone_number, :string
    remove_column :users, :available_credits, :string
    remove_column :users, :address, :string
    remove_column :users, :rut_file, :string
    remove_column :users, :photo_file, :string
    remove_column :users, :population_center_id, :string
    remove_column :users, :mining_register_file, :string
    remove_column :users, :legal_representative, :string
    remove_column :users, :id_document_file, :string
    remove_column :users, :nit_number, :string
    remove_column :users, :city_id, :string
  end
end
