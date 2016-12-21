module Reports
  module Taxes
    class Report
      attr_accessor :response

      def initialize()
        @response = {}
        @response[:success] = false
        @response[:errors] = []
      end

      def call(options = {})
        validate_options(options)
        generate!(options)
      rescue => exception
        @response[:success] = false
        @response[:errors] << exception.message
      end

      def generate!(options)
        @order = options[:order]
        @movements = TransactionMovement.where(type: @order.type)
        create_report(@movements, @order)
      end

      def create_report(movements, order)
        seller_regime = order.seller.setting.regime_type
        buyer_regime  = order.buyer.setting.regime_type
        report = {
          movements: find_values(movements, order, order.price.round(0), 'movements'),
          taxes:  get_taxes(seller_regime, buyer_regime, order.price.round(0), order.type),
          payments: find_values(movements, order, order.price.round(0), 'payments'),
        }
        report.merge!(inventories: find_values(movements, order, order.purchases_total_value.round(0), 'inventories')) if order.type == 'sale'
      end

      def find_values(movements, order, movement_value, block_name)
        movements.where(block_name: block_name).each_with_object([])  do |movement, array|
          array << 
            OpenStruct.new( 
              count:  movement.puc_account.code.to_s,
              name:   movement.puc_account.name.to_s,
              debit:  debit?(order.type, movement.puc_account_id, block_name) ?  movement_value : '',
              credit: debit?(order.type, movement.puc_account_id, block_name) ? '' : movement_value
            )
        end
      end

      def get_taxes(seller_regime, buyer_regime, price, order_type)
        tax_rules = TaxRule.where(['seller_regime = ? and buyer_regime = ?', seller_regime, buyer_regime])
        tax_rules.each_with_object([]) do |tax_rule, array|
          array << 
            OpenStruct.new( 
              count:  tax_rule.tax.puc_account.code.to_s,
              name:   tax_rule.tax.puc_account.name.to_s,
              debit:  debit?(order_type, tax_rule.tax.puc_account_id, 'taxes') ? calc_porcent(tax_rule, price) : '',
              credit: debit?(order_type, tax_rule.tax.puc_account_id, 'taxes') ? '' : calc_porcent(tax_rule, price)
            )
        end
      end

      def debit?(order_type, puc_account_id, block_name)
        movement = TransactionMovement.find_by(puc_account_id: puc_account_id, type: order_type, block_name: block_name)
        return nil unless movement
        movement.afectation.upcase == 'D' ? true : false
      end

      def calc_porcent(rule_tax, price)
        (rule_tax.tax.porcent * price / 100).round(0)
      end

      def validate_options(options)
        raise "You must to provide a order option" if options[:order].blank?
      end
    end
  end
end
