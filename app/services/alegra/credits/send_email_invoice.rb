module Alegra
  module Credits
    class SendEmailInvoice
      attr_accessor :response, :date
      attr_reader :client

      def initialize(options={})
        @response = {}
        @response[:success] = false
        @response[:errors] = []
        @client = Alegra::Client.new(APP_CONFIG[:ALEGRA_USERNAME], APP_CONFIG[:ALEGRA_TOKEN])
      end

      #
      # Main process
      #
      def call(options={})
        validate_options(options)
        ActiveRecord::Base.transaction do
          invoice = client.invoices.send_by_email(options[:credit_billing].alegra_id, invoice_mapping(options))
          @response[:success] = invoice.present?
          # TODO: create the emailed field!
          # options[:credit_billing].update_attributes(invoiced: true)
          @response
        end
        rescue Exception => e
          # options[:credit_billing].update_attributes(invoiced: false)
          @response[:errors] << e.message
          @response
      end

      # @param options [ Hash ]
      # @return [ Hash ]
      def invoice_mapping(options)
        {
          emails: [options[:credit_billing].user.email],
          # type: 'copy',
          # send_copy_to_user: true,
        }
      end


      def validate_options(options)
        raise 'You must provide a credit_billing option' unless options[:credit_billing].present?
      end
    end
  end
end