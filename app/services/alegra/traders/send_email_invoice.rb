module Alegra
  module Traders
    class SendEmailInvoice
      attr_accessor :response, :date
      attr_reader :client

      def initialize(options={})
        @response = {}
        @response[:success] = false
        @response[:errors] = []
      end

      #
      # Main process
      #
      def call(options={})
        validate_options(options)
        @client = Alegra::Client.new(options[:order].seller.email, options[:order].seller.profile.setting.alegra_token)
        ActiveRecord::Base.transaction do
          invoice = client.invoices.send_by_email(contact_alegra_id_from(options[:order]), invoice_mapping(options))
          @response[:success] = invoice.present?
          options[:order].update_attributes(invoiced: true)
          @response
        end
        rescue Exception => e
          options[:order].update_attributes(invoiced: false)
          @response[:errors] << e.message
          @response
      end

      # @param options [ Hash ]
      # @return [ Hash ]
      def invoice_mapping(options)
        {
          emails: [options[:order].buyer.email],
          # type: 'copy',
          # send_copy_to_user: true,
        }
      end

      # @param order [ Order ]
      # @return [ Integer ]
      def contact_alegra_id_from(order)
        contact_info_from(order).contact_alegra_id
      end

      # @param order [ Order ]
      # @return [ ContactInfo ]
      def contact_info_from(order)
        order.seller.contact_infos.find_by(contact: order.buyer)
      end

      def validate_options(options)
        raise 'You must provide a order option' unless options[:order].present?
      end
    end
  end
end