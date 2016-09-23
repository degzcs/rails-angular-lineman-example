class AddRegistrationStateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :registration_state, :string
  end
end
