class AddSignaturePictureFileToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :signature_picture_file, :string
  end
end
