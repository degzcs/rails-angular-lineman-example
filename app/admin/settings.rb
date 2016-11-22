ActiveAdmin.register Settings do
  menu priority: 11, label: 'Configuracion'
  permit_params :last_transaction_sequence, :data, :monthly_threshold, :fine_gram_value, :vat_percentage, :fixed_sale_agreetment, :habeas_data_agreetment

  index do
    selectable_column
    id_column
    column :last_transaction_sequence
    column :data
    actions
  end

  form do |f|
    f.inputs 'Configuracion' do
      f.input :last_transaction_sequence, label: 'Sequencia de la última transacción'
      f.input :monthly_threshold, label: 'Limite mensual por barequero/chatarrero (gramos)'
      f.input :vat_percentage, label: 'Porcentaje IVA (%)'
      f.input :fine_gram_value, label: 'Valor gramo fino (COP)'
      f.input :fixed_sale_agreetment, label: 'Texto del Acuerdo de venta', as: :text
      f.input :habeas_data_agreetment, label: 'Texto del Acuerdo de habeas', as: :text
      actions
    end
  end
end
