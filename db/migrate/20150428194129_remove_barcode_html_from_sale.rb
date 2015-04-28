class RemoveBarcodeHtmlFromSale < ActiveRecord::Migration
  def change
    remove_column :sales, :barcode_html, :text
    rename_column :sales, :barcode, :code
  end
end
