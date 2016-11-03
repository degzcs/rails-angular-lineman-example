class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.boolean :state
      t.string :alegra_token
      t.references :profile, index: true

      t.timestamps
    end
  end
end
