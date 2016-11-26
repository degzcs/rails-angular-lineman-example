# Service module
module Reports
  module Royalty
    # Service
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
        report = ::Reports::Royalty::Report.new
        draw_service = ::Reports::Royalty::DrawPdf.new
        @response = draw_service.call(
          report: report.call(options),
          date: Time.now.strftime("%Y-%m-%d"), # TODO: ask if this day is dynamic
          signature_picture: options[:signature_picture]
        )
        @pdf = draw_service
      end

      def validate_options(options)
        raise 'You must to provide a current_user option' if options[:current_user].blank?
        raise 'You must to be the legal representative to generate this report' unless options[:current_user]&.profile&.legal_representative?
        raise 'You must to provide a signature_picture option' if options[:signature_picture].blank?
      end
    end
  end
end
