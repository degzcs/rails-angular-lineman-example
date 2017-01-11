class RemoveActivityCodeFromUserSettings < ActiveRecord::Migration
  def change
    remove_column :user_settings, :activity_code, :string
  end
end
