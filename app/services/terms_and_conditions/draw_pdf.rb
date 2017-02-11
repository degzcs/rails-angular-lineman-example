require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'

class TermsAndConditions::DrawPdf < Prawn::Document
  attr_accessor :base_file
  def initialize(options = {})
    super(skip_page_creation: true)
    @response = {}
    @response[:errors] = []
  end

  def call(options = {})
  raise "You must to provide a authorize_provider presenter option" if options[:authorized_provider_presenter].blank?
  raise "You must to provide a signature picture option" if options[:signature_picture].blank?
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','acuerdo_de_habeas_data.pdf'))
    authorized_provider_presenter = options[:authorized_provider_presenter]
    signature_picture = options[:signature_picture]
    draw_file!(authorized_provider_presenter, signature_picture)
    @response[:success] = true
    @response
  end

  def file
    self
  end

  def draw_file!(authorized_provider_presenter, signature_picture)
    start_new_page({ :template => "#{base_file.path}", :template_page => 1 })
    trazoro_logo = File.open(File.join(Rails.root, 'spec','support','images','trazoro_logo.png'))
    font_size 9
    move_cursor_to 700
    text_box authorized_provider_presenter.profile.city.name, :at => [50, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    image(trazoro_logo, :at => [400, cursor], :fit => [100, 80])
    move_cursor_to 690
    text_box Time.now.strftime('%D'), :at => [50, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 650
    text_box 'Coordial Saludo,', :at => [50, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 586
    span(400, :position => :center) do
      text authorized_provider_presenter.habeas_data_agreetment_text * 1
    end

    move_cursor_to 100
    service = ::GenerateSignatureWithoutBackground.new
    signature_path = service.call(signature_picture)
    image(signature_path, :at => [50, cursor], :fit => [200, 80])
    move_cursor_to 70
    text_box authorized_provider_presenter.name, :at => [50, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 40
    text_box 'CC. ', :at => [50, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box authorized_provider_presenter.document_number, :at => [70, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
  end
end
