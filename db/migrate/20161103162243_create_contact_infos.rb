class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.integer :user_id
      t.integer :contact_id
      t.integer :contact_alegra_id
      t.boolean :contact_alegra_sync, default: false

      t.timestamps
    end
    add_index :contact_infos, [:user_id, :contact_id], unique: true
  end
end
