class AddCompanyInfoIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_info_id, :integer
  end
end
