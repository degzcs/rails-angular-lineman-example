class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :available_trazoro_service_id
      t.integer :user_setting_id
    end
    add_index :plans, [:available_trazoro_service_id, :user_setting_id], unique: true
  end
end
