ActiveAdmin.register Settings do
  menu priority: 11, label: 'Configuracion'
  permit_params :data, :monthly_threshold, :fine_gram_value, :vat_percentage, :fixed_sale_agreetment, :habeas_data_agreetment, :ros_threshold

  index do
    selectable_column
    id_column
    column :data
    actions
  end

  form do |f|
    f.inputs 'Configuracion' do
      f.input :monthly_threshold, label: 'Limite mensual por barequero/chatarrero (gramos)'
      f.input :vat_percentage, label: 'Porcentaje IVA (%)'
      f.input :fine_gram_value, label: 'Valor gramo fino (COP)'
      f.input :fixed_sale_agreetment, label: 'Texto del Acuerdo de venta', as: :text
      f.input :habeas_data_agreetment, label: 'Texto del Acuerdo de habeas', as: :text
      f.input :ros_threshold, label: 'Limite para ROS'
      actions
    end
  end
end
