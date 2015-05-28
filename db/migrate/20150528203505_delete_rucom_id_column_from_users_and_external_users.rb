class DeleteRucomIdColumnFromUsersAndExternalUsers < ActiveRecord::Migration
  def change
    remove_column :users, :rucom_id , :integer
    remove_column :external_users, :rucom_id , :integer
  end
end
