module AuthorizedProvider
  class UpdateBasicInfo
    attr_reader :authorized_provider
    attr_accessor :response

    def initialize()
      @response = {}
      @response[:success] = false
      @response[:errors] = []
    end

    def call(options={})
      validate_options(options)
      @authorized_provider = options[:authorized_provider]
      current_user = options[:current_user]

      params = options[:params]
      ActiveRecord::Base.transaction do
        ::User.audit_as(current_user) do
          audit_comment = "Updated Basic from API Request by ID: #{current_user.id}"
          @response[:success] = authorized_provider.update_attributes(
            email: params[:authorized_provider][:email],
            audit_comment: audit_comment
          )
          @response[:success] = authorized_provider.profile.update_attributes(
            address: params[:profile][:address],
            phone_number: params[:profile][:phone_number],
            audit_comment: audit_comment
            )
        end
        @response
        end
        rescue Exception => e
          @response[:errors] << e.message
          @response
    end

    def validate_options(options)
      raise 'You must to provide an authorized_provider option' unless options[:authorized_provider].present?
      raise 'You must to provide a params option' unless options[:params].present?
      raise 'You must to provide a current_user option' unless options[:current_user].present?
    end
  end
end