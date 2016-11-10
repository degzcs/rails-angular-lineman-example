module Alegra
  module Credits
    class UpdateInvoice
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
          invoice = client.invoices.update(options[:credit_billing].alegra_id, invoice_mapping(options))
          @response[:success] = options[:credit_billing].update_attributes(invoiced: true)
          @response
        end
        rescue Exception => e
          options[:credit_billing].update_attributes(invoiced: false)
          @response[:errors] << e.message
          @response
      end

      # @param options [ Hash ]
      # @return [ Hash ]
      def invoice_mapping(options)
        {
          date: options[:credit_billing].payment_date,
          due_date: options[:credit_billing].payment_date,
          status: 'closed'
        }
      end

      def validate_options(options)
        raise 'You must provide a credit_billing option' unless options[:credit_billing].present?
      end
    end
  end
end