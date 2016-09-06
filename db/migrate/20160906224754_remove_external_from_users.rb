class RemoveExternalFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :external, :boolean
  end
end
