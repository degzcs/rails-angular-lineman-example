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
        report = {}
        seller_regime = order.seller.setting.regime_type
        buyer_regime  = order.buyer.setting.regime_type
        
        report[:movements] = find_values(movements, order, order.price.round(0), 'movements')
        report[:taxes] =  get_taxes(seller_regime, buyer_regime, order.price.round(0), order.type)
        movement = report[:movements].present? ? calc_efective_payment_value(report, order) : {}
        report[:movements] = assigne_value_to_count(report[:movements], movement)
        report[:payments] = find_values(movements, order, movement.fetch(:value, nil) , 'payments')
        
        report.merge!(inventories: find_values(movements, order, order.purchases_total_value.round(0), 'inventories')) if order.type == 'sale'
        report
      end

      # param report as an array of OpenStruct elements (count: '', name: '', debit: 0, credit: 0)
      # param movement as hash {value: 100000, count: '112345', accounting_entry: 'D'}
      # return report modified
      def assigne_value_to_count(report, movement)
        return [] unless movement.present?
        if movement[:accounting_entry] == 'D'
          report.select {|obj| obj if obj.count == movement[:count]}.first.debit = movement[:value]
        elsif accounting_entry == 'C'
          report.select {|obj| obj if obj.count == movement[:count]}.first.credit = movement[:value]
        else
          nil
        end
        report
      end

      # param report as an array of OpenStruct elements (count: '', name: '', debit: 0, credit: 0)
      # param order as an instance of Order
      # return report modified
      def calc_efective_payment_value(report, order)
        if order.type == 'sale'
          credit = calc_subtotal_movements_value(report, 'C', '')
          debit  = calc_subtotal_movements_value(report, 'D', '130505')
          { value: (credit - debit).round(0), count: '130505', accounting_entry: 'D' }
        else
          credit = calc_subtotal_movements_value(report, 'C', '')
          debit  = calc_subtotal_movements_value(report, 'D', '220505')
          { value: (debit - credit).round(0), count: '220505', accounting_entry: 'D' }
        end
      end

      def calc_subtotal_movements_value(report, accounting_entry, except_count='')
        raise 'calc_subtotal_movements_value: Error, los valores permitidos son: [D, C]' unless %w(D C).include? accounting_entry.upcase
        sum = 0
        attribute = accounting_entry == 'D' ? 'debit' : 'credit'
        report.each do |k,vals|
          sum += vals.reduce(0) {|s, obj| obj.count != except_count ? s+= obj.try(attribute).to_i : s+=0 }
        end
        sum
      end


      def find_values(movements, order, movement_value, block_name)
        return [] unless movements.where(block_name: block_name)
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
        return [] unless tax_rules
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
        movement.accounting_entry.upcase == 'D' ? true : false
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
