module Alegra
  module Credits
    class CreateInvoice
      attr_reader :client
      attr_accessor :response

      ITEMS_MAPPING = {
        credits: 1
      }

      def initialize(options={})
        @response = {}
        @response[:success] = false
        @response[:errors] = []
        @client = Alegra::Client.new(APP_CONFIG[:ALEGRA_USERNAME], APP_CONFIG[:ALEGRA_TOKEN])
      end

      def call(options={})
        validate_options(options)
        ActiveRecord::Base.transaction do
          invoice = client.invoices.create(invoice_mapping(options))
          @response[:success] = options[:credit_billing].update_attributes(invoiced: true, alegra_id: invoice[:id])
        end
        rescue Exception => e
          options[:credit_billing].update_attributes(invoiced: true)
          @response[:errors] << e.message
      end

      def invoice_mapping(options)
        {
          date: options[:date].to_s,
          due_date: options[:date].to_s,
          client: options[:trader_user].alegra_id,
          items: items_from(options),
          # account_number: options[:trader_user].&account_number,
          payment_method: options[:payment_method],
          stamp: {
            generate_stamp: true
          }
        }
      end

      def items_from(options)
        [
          {
            id: ITEMS_MAPPING[:credits],
            price: options[:credit_billing].unit_price, #
            quantity: options[:credit_billing].quantity,
            discount: options[:credit_billing].discount_percentage,
            description: 'Créditos para usar los servicios Trazoro.',
            tax: [
                    {
                      id: 3, #TODO: create iva id on alegra
                    }
                 ],
          }
        ]
      end

      private

      def validate_options(options)
        raise 'You must to provide a date option' unless options[:date].present?
        raise 'You must to provide a trader_user option' unless options[:trader_user].present?
        raise 'You must to provide a payment_method option' unless options[:payment_method].present?
        raise 'You must to provide a credit_billing option' unless options[:credit_billing].present?
      end
    end
  end
end
