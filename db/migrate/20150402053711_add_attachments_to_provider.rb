class AddAttachmentsToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :identification_number_file, :string
    add_column :providers, :rut_file, :string
    add_column :providers, :mining_register_file, :string
    add_column :providers, :photo_file, :string
  end
end
