class CreateRucom < ActiveRecord::Migration
  def change
    create_table :rucoms do |t|
      t.string :name
      t.string :original_name
      t.string :minerals
      t.string :location
      t.string :status
      t.string :provider_type
      t.string :rucomeable_type
      t.integer :rucomeable_id

      t.timestamps null: false
    end
    add_index :rucoms, :rucomeable_id
  end
end
