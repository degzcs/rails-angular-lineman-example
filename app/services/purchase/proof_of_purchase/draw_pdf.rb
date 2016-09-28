require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'

class Purchase::ProofOfPurchase::DrawPDF < Prawn::Document
  attr_accessor :base_file

  def initialize(options={})
    super(skip_page_creation: true)
  end

  # @return [ Purchase::PdfGenerator ] instance with the document created in memory
  def call(options={})
    raise 'You must to provide a order_presenter option' if options[:order_presenter].blank?
    raise 'You must to provide a signature_picture option' if options[:signature_picture].blank?
    order_presenter = options[:order_presenter]
    signature_picture = options[:signature_picture]
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor', 'pdfs', 'documento_equivalente_de_compra.pdf'))
    draw_file!(order_presenter, signature_picture)
  end

  # @return [ Purchase::ProofOfPurchase::DrawPDF ]
  def file
    self
  end

  private

  # Fills out the equivalent document for the created purchase
  def draw_file!(order_presenter, signature_picture)
    start_new_page(:template => base_file.path, :template_page => 1)
    # header
    move_cursor_to 778
    text_box order_presenter.ymd_time, :at => [420, cursor], :width => 80, :size => 12, :height =>  12
    move_cursor_to 720
    barcode = Barby::EAN13.new(order_presenter.code)
    outputter = Barby::PrawnOutputter.new(barcode)
    outputter.annotate_pdf(self, options = { x: 45, y: cursor })
    font ('Courier') do
      text_box order_presenter.code, :at => [45, cursor], :width => 240, :size => 12, :height =>  12
    end

    move_cursor_to 760
    text_box order_presenter.hms_time, :at => [420, cursor], :width => 80, :size => 12, :height =>  12

    # Buyer
    buyer_presenter = order_presenter.buyer_presenter
    move_cursor_to 644
    text_box buyer_presenter.company_name, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.rucom_number, :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 626
    text_box buyer_presenter.nit_number, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.name, :at => [390,cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 607
    text_box buyer_presenter.office.name, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.office.address, :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 590
    text_box buyer_presenter.city_name, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.profile.phone_number, :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # Provider
    # TODO: use seller instead provider to represent this kind of user
    seller_presenter = order_presenter.seller_presenter
    move_cursor_to 530
    text_box seller_presenter.company_name, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.name, :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 512
    text_box seller_presenter.nit_number, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.profile.document_number, :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 494
    text_box seller_presenter.rucom_number, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.profile.phone_number, :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 476
    text_box seller_presenter.profile.city_name, :at => [130, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.profile.address, :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 459
    text_box 'population center', :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # Gold batch section
    gold_batch_presenter = order_presenter.gold_batch_presenter
    if gold_batch_presenter.castellanos?
      move_cursor_to 398
      text_box gold_batch_presenter.rounded_castellanos, :at => [130, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
      # text_box "#{values[:gold_batch_presenter][:castellanos][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    if gold_batch_presenter.tomines?
      move_cursor_to 380
      text_box gold_batch_presenter.rounded_tomines, :at => [130, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
      # text_box "#{values[:gold_batch_presenter][:tomines][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    if gold_batch_presenter.reales?
      move_cursor_to 362
      text_box gold_batch_presenter.rounded_reales, :at => [130, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
      # text_box "#{values[:gold_batch_presenter][:riales][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    move_cursor_to 398
    text_box gold_batch_presenter.rounded_grams.to_s, :at => [400, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 379
    text_box gold_batch_presenter.grade.to_s, :at => [400, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 362
    text_box gold_batch_presenter.total_fine_grams, :at => [400, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    # 1.costo trazoro 
    move_cursor_to 345
    text_box "Costo Trazoro", :at => [140, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box order_presenter.trazoro_transaction_cost, :at => [400, cursor], :with => 100, :size => 10, :height => 10, :overflow => :shrink_to_fit
    # 2. IVA
    move_cursor_to 328
    text_box "IVA", :at => [140, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box order_presenter.trazoro_transaction_vat, :at => [400, cursor], :with => 100, :size => 10, :height => 10, :overflow => :shrink_to_fit
    # 3. costo trazoro total
    move_cursor_to 311
    text_box "Costo Trazoro Total", :at => [140, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box order_presenter.trazoro_transaction_total_cost, :at => [400, cursor], :with => 100, :size => 10, :height => 10, :overflow => :shrink_to_fit
    move_cursor_to 286
    text_box order_presenter.fine_gram_price.to_s, :at => [140, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 286
    text_box order_presenter.price.to_s, :at => [400, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 230
    signature = signature_picture.is_a?(Hash) ? OpenStruct.new(signature_picture) : signature_picture
    image(signature.tempfile, :at => [280, cursor], :fit => [200, 100])

    # image(signature.tempfile, :at => [36, cursor], :fit => [200, 100])
  end
end
