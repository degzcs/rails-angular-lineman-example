class UiafReport::DrawUiafReport < Prawn::Document
  def initialize
    super(:skip_page_creation => true)
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options = {})
    raise 'You must to provide a test option' if options[:order_presenter].blank?
    order_presenter = options[:order_presenter]
    begin
      generate_uiaf_report(order_presenter)
      @response[:success] = true
    rescue => exception
      @response[:success] = false
      @response[:errors] << exception.message
    end
    @response
  end

  # @return [ UiafReport::DrawUiafReport < Prawn::Document ]
  def file
    self
  end

  def generate_uiaf_report(order_presenter)
    file = File.open(File.join(Rails.root, 'vendor', 'pdfs', 'uiaf_report.pdf'))
    start_new_page({:template => "#{file.path}", :template_page => 1})

    # move_cursor_to 590
    # text_box order_presenter.seller_presenter.name, :at => [370, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 670
    text_box 'Certificado', :at => [245, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 640
    text_box 'Reporte Generado el', :at => [150, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit
    text_box order_presenter.created_at.to_s, :at => [266, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 600
    text_box 'Por este medio la Unidad de Informacion y Análisis Financiero - UIAF de Colombia certifica que el reporte', :at => [80, cursor], :width => 400, :height => 20, :overflow => :shrink_to_fit

    move_cursor_to 580
    text_box 'Compraventa Metales fue Exitoso', :at => [80, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 530
    text_box 'No.Radicaion', :at => [180, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 515
    text_box 'Entidad', :at => [210, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    buyer_presenter = order_presenter.buyer_presenter

    text_box buyer_presenter.company_name.to_s, :at => [260, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 500
    text_box 'Usuario que realizo cargue de la info', :at => [55, cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit
    text_box buyer_presenter.name, :at => [260, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 485
    text_box 'Medio de entrega de la info', :at => [105, cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit
    text_box 'En linea', :at => [260, cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 470
    text_box 'Fecha de radicacion', :at => [141, cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 455
    text_box 'Fecha inicial a la que corresponde reporte', :at => [55, cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 440
    text_box 'Fecha final a la que corresponde reporte', :at => [53, cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 426
    text_box 'No. de registros involucrados en el reporte', :at => [53, cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit
  end
end
