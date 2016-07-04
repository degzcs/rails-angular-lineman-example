require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'

class Sale::ProofOfSale::DrawPDF < Prawn::Document

  attr_accessor :base_file

  def intiliazer(options={})
  end

  def call(options={})
    raise "You must to provide a sale_presenter option" if options[:sale_presenter].blank?
    sale_presenter = options[:sale_presenter]
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','documento_equivalente_de_venta.pdf'))
    draw_file!(sale_presenter)
    self
  end

   def draw_file!(sale_presenter, counter=' Pending...')

    start_new_page({:template => "#{base_file.path}" , :template_page => 1})

    # Header
    #move_down 60
    move_cursor_to 995
    text_box sale_presenter.ymd_time, :at => [420,cursor] , :width => 80, :size => 11 , :height =>  11, :overflow => :shrink_to_fit

    move_cursor_to 978
    text_box sale_presenter.hms_time , :at => [420,cursor], :width => 80, :size => 11 , :height =>  11, :overflow => :shrink_to_fit

    move_cursor_to 959
    text_box "#{counter}" , :at => [420,cursor] , :width => 80, :size => 11 , :height =>  11, :overflow => :shrink_to_fit

    move_cursor_to 940
    # TODO: wth? this number has to be autogenerated!!!
    barcode = Barby::EAN13.new(sale_presenter.code)
    outputter = Barby::PrawnOutputter.new(barcode)
    outputter.annotate_pdf(self,options = { x:45 , y:cursor })
    move_cursor_to 935
    font ("Courier") do
      text_box sale_presenter.code , :at => [48 , cursor], :width => 90, :size => 11 , :height =>  11, :overflow => :shrink_to_fit
    end

    # Buyer
    # NOTE: I will leave buyer instead client in order to make the migrato to the new way to save
    # the sales and purchases (Perhaps a table called Transactions)
    buyer_presenter = sale_presenter.buyer_presenter
    move_cursor_to 859
    text_box buyer_presenter.company_name, :at => [130,cursor], :width => 170 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.name, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 841
    text_box buyer_presenter.document_type, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.profile.nit_number, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 823
    text_box buyer_presenter.profile.document_number, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.profile.address, :at => [380,cursor], :width => 170 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 805
    text_box buyer_presenter.rucom_number, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box buyer_presenter.email, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 787
    text_box buyer_presenter.profile.phone_number, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit


    # Seller
    seller_presenter = sale_presenter.seller_presenter
    move_cursor_to 725
    text_box seller_presenter.company_name, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.name, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 707
    text_box seller_presenter.document_type, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.profile.nit_number, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 689
    text_box seller_presenter.profile.document_number, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.profile.address, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 671
    # TODO: double check why this address is twice
    text_box seller_presenter.profile.address, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box seller_presenter.email, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 653
    text_box seller_presenter.profile.phone_number, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # Carrier

    courier_presenter = sale_presenter.courier_presenter
    move_cursor_to 591
    text_box courier_presenter.first_name, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box courier_presenter.phone_number, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 573
    text_box courier_presenter.last_name, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box courier_presenter.address, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 554
    text_box courier_presenter.id_document_number, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    text_box courier_presenter.company_name, :at => [380,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 538
    text_box courier_presenter.nit_company_number, :at => [130,cursor], :width => 170, :size => 10, :height =>  10, :overflow => :shrink_to_fit

    # Selected Batches

    gold_batch_presenters = sale_presenter.gold_batch_presenters
    move_cursor_to 460
    gold_batch_presenters.each do |gold_batch_presenter|
      seller_presenter = gold_batch_presenter.seller_presenter
      text_box gold_batch_presenter.goldomable_id.to_s, :at => [50,cursor], :width => 65 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
      text_box seller_presenter.id.to_s , :at => [130,cursor], :width => 70 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
      text_box seller_presenter.company_name, :at => [233,cursor], :width => 120 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
      text_box gold_batch_presenter.origin_certificate_number, :at => [392,cursor], :width => 70 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
      text_box gold_batch_presenter.fine_grams.to_s, :at => [477,cursor], :width => 70, :size => 10, :height =>  10, :overflow => :shrink_to_fit
      text_box seller_presenter.rucom_number, :at => [560,cursor], :width => 70 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
      move_down 20
    end

    # Totals

    move_cursor_to 233
    text_box sale_presenter.fine_grams.to_s, :at => [465,cursor], :width => 90 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 215
    text_box sale_presenter.grams.to_s, :at => [465,cursor], :width => 90 , :size => 10 , :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 197
    text_box sale_presenter.grade.to_s, :at => [465,cursor], :width => 90 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
    move_cursor_to 179
    text_box sale_presenter.price.to_s, :at => [465,cursor], :width => 90 , :size => 10, :height =>  10, :overflow => :shrink_to_fit
  end
end