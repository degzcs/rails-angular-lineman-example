ActiveAdmin.register TaxRule do
  menu priority: 15, label: 'Mod.Tributario - Reglas de Impuestos'
  permit_params :tax_id, :transaction_type, :seller_regime, :buyer_regime

  index do
    selectable_column
    id_column
    column :tax
    column :transaction_type
    column :seller_regime
    column :buyer_regime
    actions
  end

  form do |f|
    f.inputs 'Reglas de Impuesto' do
      f.input :transaction_type, label: 'Tipo de Transacción', collection: Order.by_types.map { |x| [x, x] }
      f.input :seller_regime, label: 'Regimen del Vendedor', collection: UserSetting.regime_types_for_select
      f.input :buyer_regime, label: 'Regimen del Comprador', collection: UserSetting.regime_types_for_select
      f.input :tax, label: 'Impuesto', collection: Tax.taxes_for_select
      actions
    end
  end
end
