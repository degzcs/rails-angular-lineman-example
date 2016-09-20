class Company::Registration
  attr_accessor :legal_representative
  attr_accessor :company
  attr_accessor :response

  def initialize
    @response = {}
    @response[:errors] = []
  end

  def call(options={})
    raise 'You must to provide a company_data option' if options[:company_data].blank?
    raise 'You must to provide a legal_representative_data option' if options[:legal_representative_data].blank?
    # @response[:errors] = "Error, don't got the options call"
    options.deep_symbolize_keys!
    @company = update_company_from(options[:company_data])
    user_data = options[:legal_representative_data].merge(office: company.main_office)
    @legal_representative = create_legal_representative_from(user_data)
    # associate legal representative with the main company office
    company.update_attributes(legal_representative: legal_representative)
    @response
  end

  # @param user_data [ Hash ]
  # @return [ User ]
  def create_legal_representative_from(user_data)
    user = User.new(user_data.except(:profile_attributes))
    user.roles << Role.find_by(name: 'trader')
    user.save!
    user.build_profile(user_data[:profile_attributes])
    user.profile.legal_representative = true
    @response[:success] = user.save
    @response[:errors] << user.errors.full_messages
    user
  end

  # @param company_data [ Hash ]
  # @param legal_representative [ User ]
  # @return [ Company ]
  def update_company_from(company_data)
    company_id = company_data[:id]
    company = Company.find(company_id)
    if company.update_attributes(company_data)
      @response[:success] = true
      company
    else
      @response[:errors] << company.errors.full_messages
    end
  end
end
