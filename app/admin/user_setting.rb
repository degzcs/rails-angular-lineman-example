ActiveAdmin.register UserSetting do
  #menu priority: 12, label: 'Preferencias de usuario'
  permit_params :profile_id, :state, :alegra_token, :fine_gram_value, :last_transaction_sequence, :regime_type, :activity_code, :scope_of_operation, :organization_type, :self_holding_agent

  index do
    selectable_column
    id_column
    column :profile_id
    column :state
    column :alegra_token
    column :fine_gram_value
    column :last_transaction_sequence
    column :regime_type
    column :activity_code
    column :scope_of_operation
    column :organization_type
    column :self_holding_agent
    actions
  end

  form do |f|
    f.inputs 'Configuracion' do
      f.input :profile, label: 'Representante Legal', collection: User.legal_representatives_for_select
      f.input :state, label: 'Estado', collection: UserSetting.holding_agents_for_select
      f.input :fine_gram_value, label: 'Valor Gramo Fino'
      f.input :alegra_token, label: 'Alegra Token'
      f.input :last_transaction_sequence, label: 'Última secuencia de transacciones'
      f.input :regime_type, label: 'Tipo de Regimen', collection: UserSetting.regime_types_for_select
      f.input :activity_code, label: 'Codigo de Atividad RUT', collection: UserSetting.code_activities_for_select
      f.input :scope_of_operation, label: 'Ambito de Operación', collection: UserSetting.scope_operations_for_select
      f.input :organization_type, label: 'Tipo de Organización'
      f.input :self_holding_agent, label: 'Autorretenedor', collection: UserSetting.holding_agents_for_select

      actions
    end
  end
end
