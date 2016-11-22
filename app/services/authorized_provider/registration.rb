module AuthorizedProvider
  class Registration
    attr_reader :authorized_provider
    attr_accessor :response

    def initialize()
      @response = {}
      @response[:success] = false
      @response[:errors] = []
    end

    # Main Process
    # @param options [ Hash ]
    #     - authorized_provider [ User ]
    #     - formatted_params [ Hash ]
    #       -- profile [ Hash ]
    #       -- authorized_provider [ Hash ]
    #       -- signature picture
    #       -- signature picture
    def call(options={})
      validate_options(options)
      @authorized_provider = options[:authorized_provider]
      formatted_params = options[:formatted_params]
      current_user = options[:current_user]
      ActiveRecord::Base.transaction do
        authorized_provider.roles << Role.find_by(name: 'authorized_provider') unless authorized_provider.authorized_provider?
        ::User.audit_as(current_user) do
          audit_comment = "Updated from API Request by ID: #{current_user.id}"
          @response[:success] = authorized_provider.profile.update_attributes(formatted_params[:profile].merge(audit_comment: audit_comment))
          @response[:success] = authorized_provider.update_attributes(
            formatted_params[:authorized_provider].merge(audit_comment: audit_comment)
          )
          @response[:success] = authorized_provider.rucom.update_attributes(formatted_params[:rucom])
          authorized_provider.authorized_provider_complete? unless authorized_provider.completed?
        end
        # TODO: Has this service reponse?
        habeas_service = ::TermsAndConditions::HabeasDataAgreetmentService.new
        habeas_service.call(
          authorized_provider: authorized_provider,
          signature_picture: formatted_params[:signature_picture]
        )
        @response
      end
    rescue StandardError => e
      @response[:errors] << e.message
      @response
    end

    def validate_options(options)
      raise 'You must to provide an authorized_provider option' unless options[:authorized_provider].present?
      raise 'You must to provide an formatted_params option' unless options[:formatted_params].present?
    end
  end
end
