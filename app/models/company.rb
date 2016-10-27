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
#  registration_state       :string(255)
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

  validates :nit_number, presence: true
  validates :address, presence: true
  validates :city, presence: true

  #
  # Callbacks
  #

  after_save :update_basic_office!
  before_destroy :is_deletable?

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

  #
  # State Machine for registration_state field
  #

  state_machine :registration_state, initial: :inserted_from_rucom do
    # after_transition on: :complete, do: :complementary_attributes
    # before_transition on: :inserted_from_rucom, do: :complementary_attributes
    # before_transition on: :draf, do: :there_are_empty_fields
    after_failure :on => :failure, :do => :it_has_errors
    event :pause do
      transition [:inserted_from_rucom, :failure] => :draft
    end
    event :complete do
      transition [:inserted_from_rucom, :draft] => :completed
    end
    event :failure do
      transition [:inserted_from_rucom, :draft, :completed] => :failed
    end

    state :failed
    state :draft do
      validates :nit_number, presence: true
      validates :address, presence: true
      validates :city, presence: true
    end
    state :completed do
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
      validates :address, presence: true
      validates :city, presence: true
    end
  end

  #
  # Instance Methods
  #

  def it_has_errors
    self.registration_state = 'failed'
  end

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
  def update_basic_office!
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
    if self.legal_representative&.purchases.present? || self.legal_representative&.sales.present?
      errors.add(:legal_representative, 'Esta compañía no se puede borrar porque esta aún relacionada con almenos una Order')
    end
  end
end
