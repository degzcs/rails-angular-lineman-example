class AddPolymorphicProviderTypeToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases , :provider_type , :string
  end
end
