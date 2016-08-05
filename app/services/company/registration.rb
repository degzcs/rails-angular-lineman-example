class Company::Registration

  attr_accessor :legal_representative
  attr_accessor :company
  attr_accessor :response

  def initialize
    @response = {}
    @response[:errors] = []
  end

  def call(options={})
    raise 'You must to provide a legal_representative_data option' if options[:legal_representative_data].blank?
    raise 'You must to provide a company_data option' if options[:company_data].blank?
    raise 'You must to provide a rucom option' if options[:rucom].blank?
    # @response[:errors] = "Error, don't got the options call"
    @legal_representative = create_legal_representative_from(options[:legal_representative_data])
    @company = create_company_from(options[:company_data], legal_representative, options[:rucom])
    # associate legal representative with the main company office
    legal_representative.update_column(:office_id, company.main_office.id) if legal_representative.persisted? && company.persisted?
    @response
  end

  # @param user_data [ Hash ]
  # @return [ User ]
  def create_legal_representative_from(user_data)
    user = User.new(user_data)
    user.profile.legal_representative = true
    @response[:success] = user.save
    @response[:errors] << user.errors.full_messages
    user
  end

  # @param company_data [ Hash ]
  # @param legal_representative [ User ]
  # @return [ Company ]
  def create_company_from(company_data, legal_representative, rucom)
    company = Company.create(
      company_data.merge(legal_representative: legal_representative, rucom: rucom)
    )
    @response[:success] = company.save
    @response[:errors] << company.errors.full_messages
    company
  end
end
