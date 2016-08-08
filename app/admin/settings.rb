ActiveAdmin.register Settings do
  menu priority: 11, label: 'Configuracion'
   permit_params :data, :monthly_threshold, :gold_value_per_fine_gram
  # actions :update, :index
  index do
    selectable_column
    id_column
    column :data
    actions
  end

  form do |f|
    f.inputs 'Configuracion' do
      f.input :monthly_threshold
      f.input :gold_value_per_fine_gram
      actions
    end
  end
end