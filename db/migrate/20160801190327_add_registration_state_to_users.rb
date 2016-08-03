class AddRegistrationStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registration_state, :string
  end
end
