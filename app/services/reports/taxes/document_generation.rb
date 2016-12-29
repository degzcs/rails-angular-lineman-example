module Reports
  module Taxes
    class DocumentGeneration
      attr_accessor :response
      attr_reader :pdf, :csv

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
        report = ::Reports::Taxes::Report.new
        generate_csv = ::Reports::Taxes::GenerateCsv.new
        @csv = generate_csv.call(
          report: report.call(options),
          date: options[:date] || Time.now.strftime("%Y-%m-%d_%H_%M_%S"),
          current_user: options[:current_user],
          order: options[:order]
        )
        @response[:success] = true
        self
      end

      def validate_options(options)
        raise 'You must to provide a current_user option' if options[:current_user].blank?
        raise 'You must to provied a order option to generate this report' if options[:order].blank?
        raise "You must to provide a date option" if options[:date].blank?
      end
    end
  end
end
