class AddOriginCertificateFileToSales < ActiveRecord::Migration
  def change
    add_column :sales, :origin_certificate_file, :string
  end
end
