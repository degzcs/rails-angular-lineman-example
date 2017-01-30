# == Schema Information
#
# Table name: user_settings
#
#  id                        :integer          not null, primary key
#  state                     :boolean          default(FALSE)
#  alegra_token              :string(255)
#  profile_id                :integer
#  created_at                :datetime
#  updated_at                :datetime
#  fine_gram_value           :float
#  last_transaction_sequence :integer          default(0)
#  regime_type               :string(255)
#  activity_code             :string(255)
#  scope_of_operation        :string(255)
#  organization_type         :string(255)
#  self_holding_agent        :boolean
#

class UserSetting < ActiveRecord::Base

  #
  # Associations
  #

  belongs_to :profile
  has_and_belongs_to_many :trazoro_services, :join_table => :plans, class_name: 'AvailableTrazoroService'
  has_and_belongs_to_many :rut_activities, :join_table => :user_setting_rut_activities
  #
  # Validations
  #

  validates :state, inclusion: { in: [true, false] }
  validates :profile, presence: true, uniqueness: true
  validates_uniqueness_of :alegra_token, unless: Proc.new { |user_setting| user_setting.alegra_token == 'NA'}
  validates :fine_gram_value, numericality: true

  #
  # Constants
  #
  REGIME_TYPES = {
    RS: 'Regimen Simplificado o Persona Natural',
    RC: 'Regimen Común',
    NR: 'No Responsable de IVA',
    ERTFE: 'Excento Retefuente',
    GC: 'Gran contribuyente',
    RE: 'Regimen Especial'
  }

  OPERATION_SCOPES = {
    LC:  'Local',
    RG:  'Regional',
    NAL: 'Nacional',
    MUL: 'Multinacional'
  }

  ORGANIZATION_TYPES = {
    LTDA: 'Sociedad Limitada(LTDA)',
    SA:   'Sociedad Anónima(S.A)',
    SC:   'Sociedad Colectiva(S.C)',
    SAS:  'Sociedad por Acciones Simplificada(S.A.S)'
  }

  SELF_HOLDING_AGENTS = {
    't': 'Si',
    'f': 'No'
  }

  def self.regime_types_for_select
    REGIME_TYPES.collect { |val| [val[1], val[0]] }
  end

  def self.operation_scopes_for_select
    OPERATION_SCOPES.collect { |val| [val[1], val[0]] }
  end

  def self.organization_types_for_select
    ORGANIZATION_TYPES.collect { |val| [val[1], val[0]] }
  end

  def self.holding_agents_for_select
    SELF_HOLDING_AGENTS.collect { |val| [val[1], val[0]] }
  end

  def self.code_activities_for_select
    RutActivity.all.map { |val| [val.code.to_s + ' - ' + val.name.to_s, val.id] }
  end
end
