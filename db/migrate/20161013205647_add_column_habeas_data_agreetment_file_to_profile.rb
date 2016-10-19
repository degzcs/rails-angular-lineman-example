class AddColumnHabeasDataAgreetmentFileToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :habeas_data_agreetment_file, :string
  end
end
