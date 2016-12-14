ActiveAdmin.register Tax do
  menu priority: 14, label: 'Mod.Tributario - Impuestos'
  permit_params :name, :reference, :porcent, :puc_account_id

  index do
    selectable_column
    id_column
    column :name
    column :reference
    column :porcent
    column :puc_account
    actions
  end

  form do |f|
    f.inputs 'Impuesto' do
      f.input :name, label: 'Nombre'
      f.input :reference, label: 'iniciales de referencia'
      f.input :porcent, label: 'valor en Porcentaje'
      f.input :puc_account, label: 'Cuenta del PUC', collection: PucAccount.accounts_for_select
      actions
    end
  end
end
