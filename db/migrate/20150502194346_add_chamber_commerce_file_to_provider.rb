class AddChamberCommerceFileToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :chamber_commerce_file, :string
  end
end
