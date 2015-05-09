class AddDocumentFileAndRutFileAndMiningRegisterFileAndPhotoFileAndChamberCommerceFileAndPhoneNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :document_number_file, :string
    add_column :users, :rut_file, :string
    add_column :users, :mining_register_file, :string
    add_column :users, :photo_file, :string
    add_column :users, :chamber_commerce_file, :string
  end
end
