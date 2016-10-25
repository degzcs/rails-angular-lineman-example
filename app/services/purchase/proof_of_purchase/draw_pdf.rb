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
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor', 'pdfs', 'factura_digital_trazoro.pdf'))
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
    move_cursor_to 762
    text_box order_presenter.ymd_time, :at => [224, cursor], :width => 80, :size => 12, :height =>  12
    text_box order_presenter.hms_time.to_s, :at => [328, cursor], :width => 80, :size => 12, :height =>  12

    # Buyer
    buyer_presenter = order_presenter.buyer_presenter
    move_cursor_to 687
    text_box buyer_presenter.company_name.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 668
    text_box buyer_presenter.profile.document_number.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 646
    text_box buyer_presenter.rucom_number.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 668
    text_box buyer_presenter.nit_number.to_s, :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 688
    text_box buyer_presenter.name.to_s, :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 604
    text_box buyer_presenter.office.name.to_s, :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 646
    text_box buyer_presenter.office.address.to_s, :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 604
    text_box buyer_presenter.city_name.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 625
    text_box buyer_presenter.profile.phone_number.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # Provider
    # TODO: use seller instead provider to represent this kind of user
    seller_presenter = order_presenter.seller_presenter
    move_cursor_to 538
    text_box seller_presenter.company_name.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.name.to_s, :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 518
    text_box seller_presenter.nit_number.to_s, :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.profile.document_number.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 499
    text_box seller_presenter.rucom_number.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 478
    text_box seller_presenter.profile.phone_number.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 457
    text_box seller_presenter.profile.city_name.to_s, :at => [90, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 498
    text_box seller_presenter.profile.address, :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 453
    text_box 'NA', :at => [355, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    # move_cursor_to 459
    # text_box 'population center', :at => [390, cursor], :width => 150, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # Gold batch section
    gold_batch_presenter = order_presenter.gold_batch_presenter

    move_cursor_to 366
    text_box gold_batch_presenter.rounded_castellanos.to_s, :at => [186, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    # text_box "#{values[:gold_batch_presenter][:castellanos][:grams]} grs", :at => [480 , cursor], :width => 100

    move_cursor_to 346
    text_box gold_batch_presenter.rounded_tomines.to_s, :at => [186, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    # text_box "#{values[:gold_batch_presenter][:tomines][:grams]} grs", :at => [480 , cursor], :width => 100

    move_cursor_to 326
    text_box gold_batch_presenter.rounded_reales.to_s, :at => [186, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    # text_box "#{values[:gold_batch_presenter][:riales][:grams]} grs", :at => [480 , cursor], :width => 100

    move_cursor_to 286
    text_box gold_batch_presenter.rounded_grams.to_s, :at => [186, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 285
    text_box gold_batch_presenter.grade.to_s, :at => [337, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to 268
    text_box gold_batch_presenter.total_fine_grams.to_s, :at => [447, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # # 1.costo trazoro
    move_cursor_to 147
    text_box order_presenter.trazoro_transaction_cost.to_s, :at => [110, cursor], :with => 100, :size => 10, :height => 10, :overflow => :shrink_to_fit

    # # 2. IVA
    move_cursor_to 127
    text_box order_presenter.trazoro_transaction_vat.to_s, :at => [110, cursor], :with => 100, :size => 10, :height => 10, :overflow => :shrink_to_fit

    # # 3. costo trazoro total
    # move_cursor_to 311
    # text_box "Costo Trazoro Total", :at => [140, cursor], :width => 125, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    # text_box order_presenter.trazoro_transaction_total_cost.to_s, :at => [400, cursor], :with => 100, :size => 10, :height => 10, :overflow => :shrink_to_fit

    # move_cursor_to 286
    # text_box order_presenter.fine_gram_price.to_s, :at => [140, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    # move_cursor_to 286

    # Costo del oro
    move_cursor_to 166
    text_box order_presenter.real_gold_cost.to_s, :at => [110, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    
    # valor total
    move_cursor_to 88
    text_box order_presenter.total_price.to_s, :at => [410, cursor], :width => 100, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    move_cursor_to -5
    barcode = Barby::EAN13.new(order_presenter.code)
    outputter = Barby::PrawnOutputter.new(barcode)
    outputter.annotate_pdf(self, options = { x: 20, y: cursor })
    font('Courier') do
      text_box order_presenter.code.to_s, :at => [20, cursor], :width => 240, :size => 12, :height =>  12
    end

    service = ::GenerateSignatureWithoutBackground.new
    signature_path = service.call(signature_picture)
    move_cursor_to 78
    image(signature_path, :at => [340, cursor], :fit => [200, 80])
  end
end
