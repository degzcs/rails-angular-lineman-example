# Service module
module Shipment
  # Service
  module ShipmentService
    attr_reader :seller
    attr_accessor :response
  end

  def initialize(options = {})
  end

  def calls(options = {})
    validate_options(options)
    @seller = seller_based_on(options[:current_user])
    generate_shipment!
  end

  private

  def generate_shipment!
    ActiveRecord::Base.transaction do
      pdf_generation_service = ::PdfGeneration.new
      response = pdf_generation_service.call(
        draw_pdf_service: ::Shipment::DrawPdf,
        document_type: 'shipment'
      )
    end
    response
  end

  def seller_based_on(current_user)
    if current_user.has_office?
      current_user.company.legal_representative
    else
      current_user
    end
  end

  def validate_options(options)
    raise 'You must to provide a current_user option' if options[:current_user].blank?
  end
end
