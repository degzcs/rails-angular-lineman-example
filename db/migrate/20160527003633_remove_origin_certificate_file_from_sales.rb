class RemoveOriginCertificateFileFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :origin_certificate_file, :string
  end
end
