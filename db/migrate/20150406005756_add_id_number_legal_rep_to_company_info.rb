class AddIdNumberLegalRepToCompanyInfo < ActiveRecord::Migration
  def change
    add_column :company_infos, :id_number_legal_rep, :string
  end
end
