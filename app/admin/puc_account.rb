ActiveAdmin.register PucAccount do
  menu priority: 13, label: 'Mod.Tributario - PUC'
  permit_params :code, :name

  index do
    selectable_column
    id_column
    column :code
    column :name
    actions
  end

  form do |f|
    f.inputs 'Configuracion' do
      f.input :code, label: 'Número de Cuenta PUC'
      f.input :name, label: 'Nombre de la cuenta'
      actions
    end
  end
end
