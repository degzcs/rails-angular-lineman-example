class AddExternalToCompanies < ActiveRecord::Migration
  def change
    add_column :companies , :external , :boolean, default: false , null: false
  end
end
