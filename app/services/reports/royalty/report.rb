# Service module
module Reports
  module Royalty
    # Service
    class Report
      attr_reader :seller, :mineral_type, :fine_grams, :unit, :base_liquidation_price, :royalty_percentage, :total, :period, :year, :company, :mineral_presentation, :destinations
      attr_accessor :response

      PERIODS = {
        1 => { start_month: 1, end_month: 3 }, #['january', 'february', 'march'],
        2 => { start_month: 4, end_month: 6 }, #['april', 'may', 'june'],
        3 => { start_month: 7, end_month: 9 }, #['july', 'august', 'september'],
        4 => { start_month: 10, end_month: 12 }, #['october', 'november', 'december'],
      }

      def initialize()
        @response = {}
        @response[:success] = false
        @response[:errors] = []
        @mineral_type = 'ORO'
        @unit = 'gramos'
      end

      # @return [ Royalty::Report ]
      def call(options = {})
        validate_options(options)
        @seller = seller_based_on(options[:current_user])
        @period = options[:period].to_i
        selected_year = options[:selected_year]
        @mineral_presentation = options[:mineral_presentation]
        @base_liquidation_price = options[:base_liquidation_price].to_f.round(3)
        @royalty_percentage = options[:royalty_percentage].to_f
        report_for!(period, selected_year)
        @response[:success] = true
        self
      end

      # NOTE: this method will be neccesary when the shipment service will be charged in a independent service
      def seller_based_on(current_user)
        if current_user.has_office?
          current_user.company.legal_representative
        else
          current_user
        end
      end

      # @param period [ Integer ]
      # @param selected_year [ String ]
      def report_for!(period, selected_year)
        orders = Order.where(seller: seller, transaction_state: 'completed', payment_date: period_range_from(period, selected_year))
        @fine_grams = orders.map(&:fine_grams).sum.round(3)
        @total = (fine_grams*base_liquidation_price*(royalty_percentage/100)).round(3)
        @year = "01/01/#{year}".to_date.strftime("%y")
        @company = seller.company
        @destinations = orders.map{ |order| order.buyer.company }.compact.flatten.uniq
      end

      # @param period [ Integer ]
      # @param selected_year [ String ]
      # @return [ Range ]
      def period_range_from(period, selected_year)
        months_range = PERIODS[period]
        start_time = start_time_from(months_range, selected_year)
        end_time = end_time_from(months_range, selected_year)
        (start_time .. end_time)
      end

      # @param months_range [ Hash ]
      # @param selected_year [ String ]
      # @return [ ActiveSupport::TimeWithZone ]
      def start_time_from(months_range, selected_year)
        "01/#{ months_range[:start_month] }/#{selected_year}".to_date.beginning_of_month.beginning_of_day
      end

      # @param months_range [ Hash ]
      # @param selected_year [ String ]
      # @return [ ActiveSupport::TimeWithZone ]
      def end_time_from(months_range, selected_year)
        "01/#{ months_range[:end_month] }/#{selected_year}".to_date.end_of_month.end_of_day
      end

      def validate_options(options)
        raise 'You must to provide a current_user option' if options[:current_user].blank?
        raise 'You must to provide a period option' if options[:period].blank?
        raise 'You must to provide a selected_year option' if options[:selected_year].blank?
        raise 'You must to provide a mineral_presentation option' if options[:mineral_presentation].blank?
        raise 'You must to provide a base_liquidation_price option' if options[:base_liquidation_price].blank?
        raise 'You must to provide a royalty_percentage option' if options[:royalty_percentage].blank?
      end
    end
  end
end
