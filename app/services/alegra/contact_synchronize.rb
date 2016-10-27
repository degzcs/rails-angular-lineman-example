module Alegra
  # This class is incharged to synchronize the trazoro user (trader) with its contact register on Alegra plataform
  class ContactSynchronize
    attr_reader :user, :client
    attr_accessor :response


    # @param user [ User ]
    def initialize(user)
      @response = {}
      @response[:success]=false
      @response[:errors] = []
      @user = user
      @client = Alegra::Client.new(APP_CONFIG[:ALEGRA_USERNAME], APP_CONFIG[:ALEGRA_TOKEN])
    end

    # @return [ Boolean ] true if the user was sync successfuly and false if not
    def call
      ActiveRecord::Base.transaction do
        contact = client.contacts.create(user_attributes)
        @response[:success] = user.update_attributes(alegra_id: contact[:id], alegra_sync: true)
      end
      rescue Exception => e
        user.update_attributes(alegra_sync: false)
        @response[:errors] << e.message
    end

    private

    def user_attributes
      user_presenter = UserPresenter.new(user, nil)
      {
        name: user_presenter.name
      }
    end
  end
end