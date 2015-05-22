class AddNewUserAndExternalUserFields < ActiveRecord::Migration
  def change
    add_column :external_users, :document_expedition_date, :date
    rename_column :external_users , :identification_number_file, :document_number_file
    remove_column :external_users, :city, :string
    remove_column :external_users, :state, :string
  end
end
