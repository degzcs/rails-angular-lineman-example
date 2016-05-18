class AddLegalRepresentativeIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :legal_representative_id, :integer
    add_index :companies, :legal_representative_id
  end
end
