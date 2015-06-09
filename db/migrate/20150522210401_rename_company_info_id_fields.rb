class RenameCompanyInfoIdFields < ActiveRecord::Migration
  def change
    rename_column :users , :company_info_id, :company_id
    add_reference :external_users, :company, index: true
  end
end
