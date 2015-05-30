class RemoveTrazoroUserIdAndTrazoroUserTypeFromRucoms < ActiveRecord::Migration
  def change
    remove_column :rucoms, :trazoro_user_id, :integer
    remove_column :rucoms, :trazoro_user_type, :string
  end
end
