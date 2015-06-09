class AddChamberOfCommerceFileToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :chamber_of_commerce_file, :string
  end
end
