require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'

class Purchase::PdfGenerator < Prawn::Document

  attr_accessor :base_file

  def intialize(options={})
    # super(:skip_page_creation => true)
  end

  # @return [ Purchase::PdfGenerator ] instance with the document created in memory
  def call(options={})
    raise "You must to provide a purchase_presenter option" if options[:purchase_presenter].blank?
    purchase_presenter = options[:purchase_presenter]
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','documento_equivalente_de_compra.pdf'))
    draw_file!(purchase_presenter)
    self
  end

  private

  # Fills out the equivalent document for the created purchase
  def draw_file!(purchase_presenter)
    start_new_page({:template => base_file.path , :template_page => 1})

    # header
    move_cursor_to 778
    text_box purchase_presenter.ymd_time, :at => [420,cursor] , :width => 80, :size => 12 , :height =>  12
    move_cursor_to 720
    barcode = Barby::EAN13.new(purchase_presenter.code)
    outputter = Barby::PrawnOutputter.new(barcode)
    outputter.annotate_pdf(self, options = { x: 45 , y: cursor })
    font ("Courier") do
      text_box purchase_presenter.code, :at => [45 , cursor] , :width => 240, :size => 12 , :height =>  12
    end

    move_cursor_to 760
    text_box purchase_presenter.hms_time , :at => [420,cursor], :width => 80, :size => 12 , :height =>  12

    # Buyer
    buyer_presenter = purchase_presenter.buyer_presenter
    move_cursor_to 644
    text_box buyer_presenter.company_name, :at => [130,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.rucom_number, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 626
    text_box buyer_presenter.nit, :at => [130,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.name, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 607
    text_box buyer_presenter.office.name, :at => [130,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.office.address, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 590
    text_box buyer_presenter.city_name, :at => [130,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.phone_number, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit


    # Provider
    provider_presenter = purchase_presenter.provider_presenter
    move_cursor_to 530
    text_box provider_presenter.company_name, :at => [130,cursor], :width => 150 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit
    text_box provider_presenter.name, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 512
    text_box provider_presenter.nit, :at => [130,cursor], :width => 150, :size => 10 , :height =>  10, :overflow => :shrink_to_fit
    text_box provider_presenter.document_number, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 494
    text_box provider_presenter.rucom_record, :at => [130,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box provider_presenter.phone_number, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 476
    text_box provider_presenter.city_name, :at => [130,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box provider_presenter.address, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 459
    text_box "population center", :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # Gold batch section
    gold_batch_presenter = purchase_presenter.gold_batch_presenter
    if gold_batch_presenter.castellanos?
      move_cursor_to 398
      text_box gold_batch_presenter.rounded_castellanos , :at => [130 , cursor] , :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
      # text_box "#{values[:gold_batch_presenter][:castellanos][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    if gold_batch_presenter.tomines?
      move_cursor_to 380
      text_box gold_batch_presenter.rounded_tomines , :at => [130 , cursor] , :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
      # text_box "#{values[:gold_batch_presenter][:tomines][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    if gold_batch_presenter.reales?
      move_cursor_to 362
      text_box gold_batch_presenter.rounded_reales , :at => [130 , cursor] , :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
      # text_box "#{values[:gold_batch_presenter][:riales][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    move_cursor_to 398
    text_box gold_batch_presenter.rounded_grams, :at => [400 , cursor] , :width => 125 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 379
    text_box gold_batch_presenter.grade.to_s, :at => [400 , cursor] , :width => 125 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 362
    text_box gold_batch_presenter.total_fine_grams, :at => [400 , cursor] , :width => 125 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 286
    text_box purchase_presenter.fine_gram_price, :at => [140 , cursor] , :width => 100 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 286
    text_box purchase_presenter.price.to_s, :at => [400 , cursor] , :width => 100 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit
  end
end