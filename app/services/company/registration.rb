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
    options.deep_symbolize_keys!
    @company = update_company_from(options[:company_data])
    user_email = options[:legal_representative_data][:email]
    legal_representative_data = options[:legal_representative_data]
    validates_user_exist(user_email, legal_representative_data)
    @response[:success] = @response[:errors].blank?
    @response
  rescue StandardError => e
    @response[:errors] << e
    @response[:success] = false
    @response
  end

  # @param user_email[ String ]
  # @param legal_representative_data[ Hash ]
  def validates_user_exist(user_email, legal_representative_data)
    user = User.find_by(email: user_email)
    if user.present?
      update_legal_representative_from(user, legal_representative_data)
    else
      user_data = legal_representative_data.merge(office: company.main_office)
      @legal_representative = create_legal_representative_from(user_data)
      # associate legal representative with the main company office
      company.update_attributes(legal_representative: legal_representative)
      company.complete || company.pause # NOTE: if the company registration state doesn't apply to completed state it is going to stay on draft state
    end
  end

  # @param user_data [ Hash ]
  # @return [ User ]
  def create_legal_representative_from(user_data)
    user = User.new(user_data.except(:profile_attributes))
    user.roles << Role.find_by(name: 'trader')
    user.build_profile(user_data[:profile_attributes])
    user.profile.legal_representative = true
    user_setting = UserSetting.new(fine_gram_value: 0.0)
    user.profile.setting = user_setting
    user.user_complete? ? user : raise('Debe proporciar todos los datos para crear el representante legal de esta empresa')
  end

  # @param user [ User ]
  # @param user_data [ Hash ]
  # @return [ User ]
  def update_legal_representative_from(user, user_data)
    user.update_attributes(user_data.except(:profile_attributes))
    user.profile.update_attributes(user_data[:profile_attributes])
    user
  end

  # @param company_data [ Hash ]
  # @param legal_representative [ User ]
  # @return [ Company ]
  def update_company_from(company_data)
    company_id = company_data[:id]
    company = Company.find(company_id)
    company.update_attributes(company_data)
    company.complete || company.pause # NOTE: if the company registration state doesn't apply to completed state it is going to stay on draft state
    company
  end
end
