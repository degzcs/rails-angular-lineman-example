#  RucomServices::Sincronize Module Allows to persist the data from scraper service in rucom table.
module RucomServices
  # This class set the format to the sent data
  class Synchronize
    attr_accessor :response
    attr_reader :scraper, :user, :user_profile, :rucom, :data, :success

    def initialize(data = {})
      self.response = {}
      @response[:errors] = []
      @data = data # { rol_name: rol_name, id_type: id_type, id_number: id_number }
      @scraper = nil
      @user_profile = nil
      @user = nil
      @rucom = nil
    rescue StandardError => e
      @response[:errors] << "Sincronize.initialize: error => #{e}"
    end

    def call(data: {})
      @data ||= data
      @scraper = RucomServices::Scraper.new(@data)
      first_or_create_user_from_rucom
      @response[:success] = @response[:errors].blank?
      self
    rescue StandardError => e
      @response[:errors] << "Sincronize.call: error => #{e}"
      @response[:success] = false
      self
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
      msg = message || "The rucom dosen't exist for this id_number: #{@data[:id_number]}"
      raise msg
    end

    def user_registration_state_completed?
      @user_profile.user.completed?
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

    private

    def create_rucom
      if @scraper.is_there_rucom && @scraper.virtus_model.save
        @rucom = @scraper.virtus_model.rucom
      end
      @rucom.present?
    end

    def create_user_and_profile
      profile_arguments = { document_number: @data[:id_number], first_name: @scraper.virtus_model.name }
      # @user_profile = User.new({ profile_attributes: profile_arguments }, personal_rucom: @rucom)
      @user = User.new(profile_attributes: profile_arguments)
      @user.save!(validate: false)
      @user_profile = @user.profile
      @user.personal_rucom = @rucom
      @user.present? && @user_profile.present?
    end
  end
end