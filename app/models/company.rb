# == Schema Information
#
# Table name: companies
#
#  id                       :integer          not null, primary key
#  nit_number               :string(255)
#  name                     :string(255)
#  email                    :string(255)
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  chamber_of_commerce_file :string(255)
#  external                 :boolean          default(FALSE), not null
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  legal_representative_id  :integer
#  address                  :string(255)
#  city_id                  :integer
#

class Company < ActiveRecord::Base
  #
  # Associations
  #

  has_many :offices, dependent: :destroy
  # has_many :external_users # TODO: check this association asap
  has_one :rucom, as: :rucomeable
  belongs_to :legal_representative, class_name: 'User'
  belongs_to :city
  accepts_nested_attributes_for :legal_representative

  #
  # Validations
  #

  # TODO: change the id_number_legal_rep to legal_representative_id_number and id_type_legal_rep to
  # legal_representative_id_type; and maybe add this person to the system to.
  validates :nit_number, presence: true
  validates :name, presence: true
  validates :legal_representative, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :chamber_of_commerce_file, presence: true
  validates :rut_file, presence: true
  # TODO: this mining_register_file field has to be deleted, it not make sense here
  # validates :mining_register_file, presence: true
  validates :rucom, presence: true
  validates_uniqueness_of :nit_number

  #
  # Callbacks
  #

  after_save :create_basic_office!
  before_destroy :is_deletable?

  #
  # Scopes
  #

  #
  # Delagates
  #

  delegate :available_credits, to: :legal_representative
  delegate :state, to: :city

  #
  # Uploaders
  #

  mount_uploader :rut_file, DocumentUploader
  mount_uploader :mining_register_file, DocumentUploader
  mount_uploader :chamber_of_commerce_file, DocumentUploader

  # TODO: avoid destroy company if there are users associated to it.

  #
  # Instance Methods
  #

  # Gets the main office associated to this company
  # @return [ Office ]
  def main_office
    self.offices.where(name: 'principal').first
  end

  # @return [ String ] with the address
  # def address
  #   main_office.address
  # end

  # NOTE: These methods are temporal, created in order to don't break the app.
  def id_number_legal_rep
    legal_representative.document_number
  end

  def id_type_legal_rep
    'CC'
  end

  def as_json(params={})
    super(params)
  end

  def as_indexed_json(options={})
    as_json(
      include:[:rucom, legal_representative: { include: :profile }],
      methods: [:address]
      ).merge('city' => self.city.name, 'state' => self.state.name, 'country' => self.state.country.name )
  end

  private

  # This ensure that every company has at least one office after is created or saved
  # To have consistency this office is called PRINCIPAL and it is located in the same
  # place where the company was registered.
  def create_basic_office!
    self.offices.create(name: 'principal', city: self.city, address: self.address) if self.offices.blank?
  end

  def is_deletable?
    check_empty_company
    check_company_orders
  end

  # Double check that the company is empty. if not raise an error and avoid delete this company
  def check_empty_company
    # errors.add(:users, 'Esta compañía no se puede borrar porque esta aún relacionada con almenos un usuario EXTERNO') if self.external_users.present?
    errors.add(:users, 'Esta compañía no se puede borrar porque esta aún relacionada con almenos un usuario') if offices.map(&:users).flatten.compact.present?
  end

  # this method is to validate that the company does not have orders
  def check_company_orders
    if self.legal_representative.purchases.present? || self.legal_representative.sales.present?
      errors.add(:legal_representative, 'Esta compañía no se puede borrar porque esta aún relacionada con almenos una Order')
    end
  end
end
