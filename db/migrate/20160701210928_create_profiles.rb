class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :document_number
      t.string :phone_number
      t.float :avaible_credits
      t.string :address
      t.string :rut_file
      t.string :photo_file
      t.text :mining_authorization_file
      t.boolean :legal_representative
      t.text :id_document_file
      t.integer :nit_number
      t.references :city, index: true

      t.timestamps
    end
  end
end
