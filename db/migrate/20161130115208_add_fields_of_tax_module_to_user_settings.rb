class AddFieldsOfTaxModuleToUserSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :regime_type, :string
    add_column :user_settings, :activity_code, :string
    add_column :user_settings, :scope_of_operation, :string
    add_column :user_settings, :organization_type, :string
    add_column :user_settings, :self_holding_agent, :boolean
  end
end
