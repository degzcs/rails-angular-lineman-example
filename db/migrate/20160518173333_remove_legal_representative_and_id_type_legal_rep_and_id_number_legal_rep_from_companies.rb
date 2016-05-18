class RemoveLegalRepresentativeAndIdTypeLegalRepAndIdNumberLegalRepFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :legal_representative, :string
    remove_column :companies, :id_type_legal_rep, :string
    remove_column :companies, :id_number_legal_rep, :string
  end
end
