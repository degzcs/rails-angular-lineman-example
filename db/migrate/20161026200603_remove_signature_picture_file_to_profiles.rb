class RemoveSignaturePictureFileToProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :signature_picture_file, :string
  end
end
