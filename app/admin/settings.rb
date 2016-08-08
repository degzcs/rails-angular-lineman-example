ActiveAdmin.register Settings do
  menu priority: 11, label: 'Configuracion'
  permit_params :data, :monthly_threshold, :fine_gram_value, :vat_percentage

  index do
    selectable_column
    id_column
    column :data
    actions
  end

  form do |f|
    f.inputs 'Configuracion' do
      f.input :monthly_threshold, label: 'Limite mensual por barequero/chatarrero'
      f.input :vat_percentage, label: 'Porcentaje IVA'
      f.input :fine_gram_value, label: 'Valor gramo fino'
      actions
    end
  end
end