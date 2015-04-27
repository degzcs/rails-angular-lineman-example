class AddBarcodeHtmlToSale < ActiveRecord::Migration
  def change
    add_column :sales, :barcode_html, :text, limit: nil
  end
end
