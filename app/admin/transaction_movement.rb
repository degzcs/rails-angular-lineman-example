ActiveAdmin.register TransactionMovement do
  menu priority: 16, label: 'Mod.Tributario - Reporte de Impuestos'
  permit_params :puc_account_id, :type, :block_name, :afectation

  index do
    selectable_column
    id_column
    column :puc_account
    column :type
    column :block_name
    column :afectation
    actions
  end

  form do |f|
    f.inputs 'Configuración Reporte de Impuestos' do
      f.input :puc_account, label: 'Cuenta del PUC', collection: PucAccount.accounts_for_select
      f.input :type, label: 'tipo de transacción', collection: TransactionMovement.types_for_select
      f.input :block_name, label: 'Nombre del bloque donde aparecerá', collection: TransactionMovement.block_names_for_select
      f.input :afectation, label: 'El valor debe aparecer en el Afecte contable', collection: TransactionMovement.afectations_for_select
      actions
    end
  end
end
