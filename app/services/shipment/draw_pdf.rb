# Draw application shipment authorization and/or
class Shipment::DrawPdf < Prawn::Document
  attr_accessor :base_file

  def initialize(options = {})
    super(skip_page_creation: true)
  end

  def call(options = {})
  raise "You must to provide a order_presenter option" if options[:order_presenter].blank?
    order_presenter = options[:order_presenter]
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','solicitud_de_autorizacion_embarque_yo_registros_previos.pdf'))
    draw_file!(order_presenter)
    self
  end

  def file
    self
  end

  def draw_file!( order_presenter, counter = 'Pending...')
    start_new_page({ :template => "#{base_file.path}", :template_page => 1 })

    # Header
    # move_down 60
    move_cursor_to 1200
    text_box "Prueba de que dibuja"
  end
end
