class RenameClientAndProviderTables < ActiveRecord::Migration
  def change
    rename_table :providers, :external_users
    rename_table :company_infos, :companies
    rename_table :clients, :external_clients
  end
end
