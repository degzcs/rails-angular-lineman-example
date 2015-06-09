class AddFilesToCompany < ActiveRecord::Migration
  def change
    add_column :companies , :rut_file , :string
    add_column :companies , :mining_register_file , :string
  end
end
