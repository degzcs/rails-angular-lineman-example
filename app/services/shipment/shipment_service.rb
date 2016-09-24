# Service module
module Shipment
  # Service
  class ShipmentService
    attr_reader :seller, :order
    attr_accessor :response
    def initialize(_options = {})
      @response = {}
      @response[:errors] = []
    end

    def call(options = {})
      validate_options(options)
      @seller = seller_based_on(options[:current_user])
      @order = options[:order]
      generate_shipment!
    end

    private

    def generate_shipment!
      ActiveRecord::Base.transaction do
        pdf_generation_service = ::PdfGeneration.new
        @response= pdf_generation_service.call(
          draw_pdf_service: ::Shipment::DrawPdf,
          document_type: 'shipment',
          order: @order
        )
      end
      response
    end

    # NOTE: this method will be neccesary when the shipment service will be charged in a independent service
    def seller_based_on(current_user)
      if current_user.has_office?
        current_user.company.legal_representative
      else
        current_user
      end
    end

    def validate_options(options)
      raise 'You must to provide a current_user option' if options[:current_user].blank?
      raise 'You must to provide a order option' if options[:order].blank?
    end
  end
end
