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
#

class UserSetting < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :profile
  has_and_belongs_to_many :trazoro_services, :join_table => :plans, class_name: 'AvailableTrazoroService'

  #
  # Validations
  #

  validates :state, inclusion: { in: [true, false] }
  validates :profile, presence: true
  validates_uniqueness_of :alegra_token
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

  SCOPE_OPERATIONS = {
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

  CODE_ACTIVITIES = {
    '01': '01- Aporte especial para la administración de justicia.',
    '02': '02- Gravamen a los movimientos financieros',
    '03': '03- Impuesto al patrimonio',
    '04': '04- Impuesto de renta y complementarios régimen especial',
    '05': '05- Impuesto de renta y complementario régimen ordinario',
    '06': '06- Ingresos y patrimonio.',
    '07': '07- Retención en la fuente a título de renta',
    '08': '08- Retención timbre nacional',
    '09': '09- Retención en la fuente en el impuesto sobre las ventas',
    '10': '10- Usuario aduanero',
    '11': '11- Ventas régimen común',
    '12': '12- Ventas régimen simplificado',
    '13': '13- Gran contribuyente',
    '14': '14- Informante de exógena',
    '15': '15- Autorretenedor',
    '16': '16- Obligación facturar por ingresos bienes y/o servicios excluidos',
    '17': '17- Profesionales de compra y venta de divisas',
    '18': '18- Precios de transferencia',
    '19': '19- Productor de bienes y/o servicios exentos (incluye exportaciones)',
    '20': '20- Obtención NIT',
    '21': '21- Declarar ingreso o salida del país de divisas o moneda l',
    '22': '22- Obligado a cumplir deberes formales a nombre de terceros',
    '23': '23- Agente de retención en ventas',
    '24': '24- Declaración consolidada precios de transferencia',
    '26': '26- Declaración individual precios de transferencia',
    '32': '32- Impuesto nacional a la gasolina y al ACPM',
    '33': '33- Impuesto nacional al consumo',
    '34': '34- Régimen simplificado impuesto nacional consumo res y bar',
    '35': '35- Impuesto sobre la renta para la equidad - CREE.',
    '36': '36- Establecimiento Permanente',
    '40': '40- Impuesto a la Riqueza',
    '41': '41- Declaración anual de activos en el exterior',
    '42': '42- Obligado a llevar contabilidad'
  }

  def self.regime_types_for_select
    REGIME_TYPES.collect { |val| [val[1], val[0]] }
  end
  
  def self.scope_operations_for_select
    SCOPE_OPERATIONS.collect { |val| [val[1], val[0]] }
  end

  def self.organization_types_for_select
    ORGANIZATION_TYPES.collect { |val| [val[1], val[0]] }
  end

  def self.holding_agents_for_select
    SELF_HOLDING_AGENTS.collect { |val| [val[1], val[0]] }
  end

  def self.code_activities_for_select
    CODE_ACTIVITIES.collect { |val| [val[1], val[0]] }
  end
end
