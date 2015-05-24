class AddClientTypeToSales < ActiveRecord::Migration
  def change
    add_column :sales , :client_type , :string
  end
end
