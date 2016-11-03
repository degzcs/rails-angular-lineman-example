ActiveAdmin.register AvailableTrazoroService do
  menu priority: 11, label: 'Servicios Trazoro'

  permit_params :name, :credits

  index do
    selectable_column
    id_column
    column :name
    column :credits
    actions
  end

  filter :name
  filter :credits

  form do |f|
    f.inputs 'Detalles Servio Trazoro' do
      f.input :name, label: 'Nombre del Servicio'
      f.input :credits, label: 'Costo en creditos del Servicio'
    end
    f.actions
  end
end
