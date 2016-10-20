require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'

class TermsAndConditions::DrawPdf < Prawn::Document
     attr_accessor :base_file, :authorized_provider_presenter, :signature_picture
  def initialize(options = {})
    super(skip_page_creation: false)
    @response = {}
    @response[:errors] = []
  end

  def call(options = {})
  raise "You must to provide a authorize_provider presenter option" if options[:authorized_provider_presenter].blank?
  raise "You must to provide a signature picture option" if options[:signature_picture].blank?
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','acuerdo_de_habeas_data.pdf'))    
    begin
      draw_file!(authorized_provider_presenter, signature_picture)
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
  
  def draw_file!(authorized_provider_presenter, signature_picture)
    start_new_page({ :template => "#{base_file.path}", :template_page => 1 })
    # Header
    # move_down 60
    # 100y/x equivale a 3cm
    # 500 -> 600 es el limite de ancho hacia la derecha (+x)
    move_cursor_to 586
    text_box "Terminos y Condiciones", :at => [200, cursor], :width => 300, :height => 15
    move_cursor_to 450
    move_cursor_to 255
    move_cursor_to 230
  end
end
