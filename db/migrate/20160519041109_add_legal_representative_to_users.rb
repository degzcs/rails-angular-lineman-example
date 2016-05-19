class AddLegalRepresentativeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :legal_representative, :boolean, default: false
  end
end
