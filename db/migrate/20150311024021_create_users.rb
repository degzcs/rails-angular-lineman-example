class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :document_number
      t.date :document_expedition_date
      t.string :phone_number

      t.timestamps
    end
  end
end
