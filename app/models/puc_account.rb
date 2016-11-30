# PucAccount class to load the tax module Puc
class PucAccount < ActiveRecord::Base
  validates :code, presence: true
  validates :name, presence: true
  validates :debit, presence: true
  validates :credit, presence: true
  validates :account_nature, presence: true

  ACCOUNT_NATURES = {
    D: 'Dédito',
    C: 'Crédito'
  }.freeze

  OPERATIONS = {
    :'+' => 'Suma',
    :'-' => 'Resta'
  }.freeze
end
