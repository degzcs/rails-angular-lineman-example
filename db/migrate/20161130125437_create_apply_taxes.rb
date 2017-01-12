class CreateApplyTaxes < ActiveRecord::Migration
  def change
    create_table :apply_taxes do |t|
      t.references :tax, index: true
      t.string :seller_regime
      t.string :buyer_regime

      t.timestamps
    end
  end
end
