module Alegra
  module Traders
    class CreateInvoice
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
        @date = options[:payment_date] || Time.now
        @client = Alegra::Client.new(options[:order].seller.email, options[:order].seller.profile.setting.alegra_token)
        ActiveRecord::Base.transaction do
          invoice = client.invoices.create(invoice_mapping(options))
          @response[:success] = options[:order].update_attributes(alegra_id: invoice[:id], payment_date: @date)
          @response = Alegra::Traders::SendEmailInvoice.new.call(order: options[:order]) if @response[:success]
          @response
        end
        rescue Exception => e
          options[:order].update_attributes(alegra_id: nil)
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
          status: 'open',
          client: contact_alegra_id_from(options[:order]),
          items: items_from(options),
          # account_number: options[:trader_user].&account_number,
          payment_method: options[:payment_method], # transfer, cash, deposit, check, credit-card, debit-card
          stamp: {
            generate_stamp: true
          }
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

      #
      # Creates a group of all items (services) that we will charge to the client (trader)
      # @param options [ Hash ]
      # @return [ Array ]
      def items_from(options)
        [
          {
            id: items_mapping[:sold_gold],
            price: unit_price_for(options[:order].price, options[:order].fine_grams), ## unit price
            quantity: options[:order].fine_grams,
            discount: 0,
            description: 'Compra de Oro',
            tax: [
                    { ##TODO: create iva id on alegra
                      id: 1, ## id 1 is for 0% VAT, but it has to change dinamically based on buyer role (exporter||trader||refinery)
                    }
                 ],
          }
        ]
      end

      def unit_price_for(total_price, quantity)
        total_price.to_f/quantity.to_f
      end

      private

      def validate_options(options)
        raise 'You must to provide a payment_method option' unless options[:payment_method].present?
        raise 'You must to provide a credit_billing option' unless options[:order].present?
        raise "The buyer has to be synchronized with Alegra (Trader alegra account not Trazoro's account) before to create an invoice" unless contact_alegra_id_from(options[:order]).present?
      end
    end
  end
end