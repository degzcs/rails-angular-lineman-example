#  RucomServices::Sincronize Module Allows to persist the data from scraper service in rucom table.
module RucomServices
  # This class set the format to the sent data
  class Synchronize
    attr_accessor :response
    attr_reader :scraper, :user, :user_profile, :rucom, :data, :success, :company

    def initialize(data = {})
      self.response = {}
      @response[:errors] = []
      @data = data # { rol_name: rol_name, id_type: id_type, id_number: id_number }
      @scraper = nil
      @user_profile = nil
      @user = nil
      @rucom = nil
      @company = nil
    rescue StandardError => e
      @response[:errors] << "Sincronize.initialize: error => #{e}"
    end

    def call(data: {})
      @data ||= data
      @scraper = RucomServices::Scraper.new(@data)
      select_company_or_user_from_rucom(@data[:rol_name])
      @response[:success] = @response[:errors].blank?
      self
    rescue StandardError => e
      @response[:errors] << "Sincronize.call: error => #{e}"
      @response[:success] = false
      self
    end

    def select_company_or_user_from_rucom(rol_name)
      case rol_name
      when 'Barequero'
        first_or_create_user_from_rucom
      when 'Chatarrero'
        first_or_create_user_from_rucom
      when 'Comercializadores'
        first_or_create_company_from_rucom
      else
        raise 'Role name No Valid!' + rol_name
      end
    end

    def success
      @response[:success]
    end

    # create user when doesn't exist or returns from the database
    def first_or_create_user_from_rucom
      if user_profile_exist?
        query_rucom_or_create_it unless user_registration_state_completed?
      elsif exist_remote_rucom?
        create_rucom
        create_user_and_profile
      else
        raises_no_exist_rucom
      end
    end

    def raises_no_exist_rucom(message = false)
      msg = message || "El rucom no existe con este documento de identidad: #{@data[:id_number]}"
      raise msg
    end

    def user_registration_state_completed?
      if @user_profile.user.completed?
        @rucom = @user_profile.user.rucom unless @user_profile.blank?
        @user = @user_profile.user
        @rucom
      end
    end

    def query_rucom_or_create_it
      if rucom_exist?
        @user = @user_profile.user
        @rucom
      elsif exist_remote_rucom?
        create_rucom && create_user_and_profile ? @rucom : raises_no_exist_rucom('Error inesperado, no se pudo crear el rucom')
      else
        raises_no_exist_rucom
      end
    end

    def user_profile_exist?
      @user_profile = Profile.find_by(document_number: @data[:id_number])
      @user_profile.present?
    end

    def rucom_exist?
      # Rucom.find_by(rucom_number: @scraper.virtus_model.rucom_number)

      # TODO, It just valids the user has a rucom because the rucom not has more information about the producer like id_number
      @rucom = @user_profile.user.rucom unless @user_profile.blank?
      @rucom.present?
    end

    def exist_remote_rucom?
      @scraper.call
      raise "create_rucom: #{@scraper.response[:errors].inspect}" unless @scraper.response[:errors].blank?
      @scraper.is_there_rucom
    end

    # methods for create company
    def first_or_create_company_from_rucom
      if company_exist?
        query_company_rucom_or_create_it
      elsif exist_remote_rucom?
        create_rucom
        create_company
      else
        raises_no_exist_rucom
      end
    end

    def company_rucom_exist?
      @rucom = @company.rucom unless @company.blank?
      @rucom.present?
    end

    def company_exist?
      @company = Company.find_by(nit_number: @data[:id_number])
      @company.present?
    end

    def query_company_rucom_or_create_it
      if company_rucom_exist?
        @rucom
      elsif exist_remote_rucom?
        create_rucom && create_company ? @rucom : raises_no_exist_rucom('Error inesperado, no se pudo crear el rucom')
      else
        raises_no_exist_rucom
      end
    end

    private

    def create_rucom
      if @scraper.is_there_rucom && @scraper.virtus_model.save
        @rucom = @scraper.virtus_model.rucom
      end
      @rucom.present?
    end

    def create_user_and_profile
      # NOTE: regimen simplificado, it could change in backend if this user exceed the regime threshold allowed by the Goverment.
      # TODO: update activity_code in frontend to be saved here.
      setting_arguments = {
        alegra_token: 'NA',
        fine_gram_value: 0.0,
        last_transaction_sequence: 'NA',
        regime_type: 'RS',
        scope_of_operation: '',
        organization_type: '',
        self_holding_agent: false,
      }
      profile_arguments = {
        document_number: @data[:id_number],
        first_name: @scraper.virtus_model.rucom.name,
      }
      # @user_profile = User.new({ profile_attributes: profile_arguments }, personal_rucom: @rucom)
      @user = User.new(profile_attributes: profile_arguments)
      @user.roles << Role.find_by(name: 'authorized_provider')
      @user.save!(validate: false)
      @user.profile.create_setting(setting_arguments)

      @user_profile = @user.profile
      @user.personal_rucom = @rucom
      @user.present? && @user_profile.present?
    end

    def create_company
      @company = Company.new(nit_number: @data[:id_number])
      @company.save!(validate: false)
      @company.rucom = @rucom
      @company.present? && @company.rucom.present?
    end
  end
end
