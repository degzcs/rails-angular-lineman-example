module Alegra
  module Credits
    class CreateInvoice
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
        @date = options[:credit_billing].payment_date || Time.now
        ActiveRecord::Base.transaction do
          invoice = client.invoices.create(invoice_mapping(options))
          @response[:success] = options[:credit_billing].update_attributes(invoiced: true, alegra_id: invoice[:id], payment_date: @date)
          @response
        end
        rescue Exception => e
          options[:credit_billing].update_attributes(invoiced: false)
          @response[:errors] << e.message
          @response
      end

      #
      # Gets all items created.These items will be our services which we will charge to the client
      # currently the only service that we are charging here is buy credits
      # @return [ Array ] of Hashes which contain the detailed info about each item.
      # See here for more info: http://developer.alegra.com/docs/lista-de-productos-o-servicios
      def items
        @items ||= client.items.list()
      end

      #
      # Converts items in key-value pairs to easily select the item (service) that will be used
      # @return [ Hash ] where its keys are the item references and the values are the item ids
      #          Ex.
      #           { buy_gold: 1, other_service: 2}
      def items_mapping
        {}.tap { |hash|
          items.each{|item| hash[item[:reference].to_s.underscore.to_sym] = item[:id]  }
        }
      end

      #
      # Incharge to arrange the service passed options in order to pass them to client to create an invoice
      # @param options [ Hash ]
      # @return [ Hash ]
      def invoice_mapping(options)
        {
          date: @date,
          due_date: @date,
          client: options[:credit_billing].user.alegra_id,
          items: items_from(options),
          # account_number: options[:trader_user].&account_number,
          payment_method: options[:payment_method],
          stamp: {
            generate_stamp: true
          }
        }
      end

      #
      # Creates a group of all items (services) that we will charge to the client (trader)
      # @param options [ Hash ]
      # @return [ Array ]
      def items_from(options)
        [
          {
            id: items_mapping[:buy_credits],
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
        raise 'You must to provide a payment_method option' unless options[:payment_method].present?
        raise 'You must to provide a credit_billing option' unless options[:credit_billing].present?
        raise 'The trader has to be synchronized with alegra before to create an invoice' unless options[:credit_billing].user.alegra_id.present?
      end
    end
  end
end
