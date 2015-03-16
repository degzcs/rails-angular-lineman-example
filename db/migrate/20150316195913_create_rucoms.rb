class CreateRucoms < ActiveRecord::Migration
  def change
    create_table :rucoms, id: false do |t|
      t.string :idrucom, primary_key: true, limit: 90
      t.text :record
      t.text :name
      t.text :status
      t.text :mineral
      t.text :location
      t.text :subcontract_number
      t.text :mining_permit
      t.datetime :updated_at

    end

    execute 'alter table rucoms alter column updated_at set default now()'

  end
end
