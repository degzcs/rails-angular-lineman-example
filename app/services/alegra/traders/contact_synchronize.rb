module Alegra
  module Traders
    # This class is incharged to synchronize the trazoro user (trader) with its contact register on Trader Alegra account
    class ContactSynchronize
      attr_reader :seller, :buyer, :contact_info, :client
      attr_accessor :response


      # @param options [ Hash ]
      #     - [ User ] seller
      #     - [ User ] buyer
      def initialize(options={})
        validate_options(options)
        @response = {}
        @response[:success] = false
        @response[:errors] = []
        @seller = options[:seller]
        @buyer = options[:buyer]
        @client = Alegra::Client.new(seller.email, seller.profile.setting.alegra_token)
      end

      # @return [ Hash ]
      #   -[ Boolean ] :success, which is true if the user was sync successfuly and false if not
      #   -[ Array ] :errors, collection of errors
      def call
        ActiveRecord::Base.transaction do
          if contact_is_synced?
            # update or do something here
          else
            contact = client.contacts.create(buyer_attributes)
            @response[:success] = seller.contact_infos.new(contact_alegra_id: contact[:id], contact_alegra_sync: true, contact: buyer).save
          end
          @response
        end
        rescue Exception => e
          contact_info.update_attributes(contact_alegra_sync: false) if contact_info.present?
          @response[:errors] << e.message
          @response
      end

      def contact_is_synced?
        contact_info.present?
      end

      # @param order [ Order ]
      # @return [ ContactInfo ]
      def contact_info_from(order)
        @contact_info ||= seller.contact_infos.find_by(contact: order.buyer)
      end

      def validate_options(options)
        raise 'You must to provide a buyer option' unless options[:buyer].present?
        raise 'You must to provide a seller option' unless options[:seller].present?
        raise 'You must to set the alegra token on user settings' unless options[:seller].profile.setting.alegra_token.present?
        raise 'You must to set the buyer email' unless options[:seller].email.present?
      end

      private

      def buyer_attributes
        user_presenter = UserPresenter.new(buyer, nil)
        {
          name: user_presenter.name
        }
      end
    end
  end
end