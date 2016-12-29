# == Schema Information
#
# Table name: taxes
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  reference      :string(255)
#  porcent        :float
#  puc_account_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

# Tax class storage the taxes for the puc accounts
class Tax < ActiveRecord::Base
  belongs_to :puc_account
  has_many :tax_rules

  validates :puc_account_id, presence: true
  validates :name, presence: true
  validates :reference, presence: true
  validates :porcent, presence: true

  def self.taxes_for_select
    Tax.all.map { |r| ["#{r.puc_account.code} - #{r.name} - #{r.porcent}", r.id]}
  end
end
