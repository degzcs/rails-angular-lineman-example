ActiveAdmin.register AvailableTrazoroService do
  menu priority: 11, label: 'Servicios Trazoro'

  permit_params :name, :credits

  controller do
    # This code is evaluated within the controller class
    def available_trazoro_service
      # Instance method
      AvailableTrazoroService.find(params[:id])
    end
  end

  sidebar 'Lista de usuarios activos con este Servicio', only: [:show] do
    ul do
      available_trazoro_service.user_settings.each do |service|
        li service.profile.first_name
      end
    end
  end

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
