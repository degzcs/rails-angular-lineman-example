# Service module
module Royalty
  # Service
  class ReportGeneration
    attr_accessor :response
    attr_reader :pdf

    def initialize()
      @response = {}
      @response[:success] = false
      @response[:errors] = []
    end

    def call(options = {})
      validate_options(options)
      generate!
    end

    def generate!
      report = ::Royalty::Report.new
      draw_service = ::Royalty::DrawPdf.new
      @reponse = draw_service.call(
        report: report.call(options),
        date: Time.now.strftime("%Y-%m-%d"), # TODO: ask if this day is dynamic
        signature_picture: signature_picture
      )
      # @pdf = service.file.render_file("#{ Rails.root }/tmp/royalty/royalty_test.pdf")
      # file_payload = File.read(saved_file)
    rescue => exception
      @response[:success] = false
      @response[:errors] << exception.message
      @response
    end

    def validate_options(options)
      raise 'You must to provide a current_user option' if options[:current_user].blank?
      raise 'You must to provide a signature_picture option' if options[:signature_picture].blank?
    end
  end
end
