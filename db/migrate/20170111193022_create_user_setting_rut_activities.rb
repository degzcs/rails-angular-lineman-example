class CreateUserSettingRutActivities < ActiveRecord::Migration
  def change
    create_table :user_setting_rut_activities do |t|
      t.references :user_setting, index: true, null: false
      t.references :rut_activity, index: true, null: false
    end
  end
end
