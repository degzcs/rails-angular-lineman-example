require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'
# Draw application shipment authorization and/or
class Shipment::DrawPdf < Prawn::Document
  attr_accessor :base_file, :order_presenter

  def initialize(options = {})
    super(skip_page_creation: false)
    @response = {}
    @response[:errors] = []
  end

  def call(options = {})
  raise "You must to provide a order_presenter option" if options[:order].blank?
    @order_presenter = OrderPresenter.new(options[:order], nil)
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','solicitud_de_autorizacion_embarque_yo_registros_previos.pdf'))    
    begin
      draw_file!(order_presenter)
      @response[:success] = true
    rescue => exception
      @response[:success] = false
      @response[:errors] << exception.message
    end
    @response
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
    ##### Buyer #######
    
  end
end
