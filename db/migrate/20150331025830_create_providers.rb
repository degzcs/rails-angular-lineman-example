class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :document_number
      t.string :type
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :address
      t.timestamps
    end
  end
end
