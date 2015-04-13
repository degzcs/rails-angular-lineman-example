class AddSellerPictureToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :seller_picture, :string
  end
end
