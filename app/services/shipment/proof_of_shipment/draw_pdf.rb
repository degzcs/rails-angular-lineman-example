# Draw application shipment authorization and/or
class Shipment::ProofOfShipment::DrawPDF < Prawn::Document
	attr_accessor :base_file

def call(options={})
    raise "You must to provide a order_presenter option" if options[:order_presenter].blank?
    order_presenter = options[:order_presenter]
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','solicitud_de_autorizacion_embarque_yo_registros_previos.pdf'))
    draw_file!(order_presenter)
    self
  end

def draw_file!()
	
end

end
