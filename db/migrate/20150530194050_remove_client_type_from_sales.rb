class RemoveClientTypeFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :client_type, :string
  end
end
