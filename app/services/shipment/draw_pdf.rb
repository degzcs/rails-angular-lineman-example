require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'
# Draw application shipment authorization and/or
class Shipment::DrawPdf < Prawn::Document
  attr_accessor :base_file, :order_presenter

  def initialize(options = {})
    super(skip_page_creation: true)
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
    buyer_presenter = order_presenter.buyer_presenter
    # Header
    # move_down 60
    # 100y/x equivale a 3cm
    # 500 -> 600 es el limite de ancho hacia la derecha (+x)
    move_cursor_to 450
    text_box buyer_presenter.city_name, :at => [500, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    ##### Buyer #######
    move_cursor_to 586
    text_box buyer_presenter.first_name, :at => [400, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box buyer_presenter.last_name, :at => [220, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 255
    text_box "trasportador",:at => [100, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
  end
end
