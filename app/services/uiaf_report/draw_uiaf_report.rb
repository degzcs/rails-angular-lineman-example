class UiafReport::DrawUiafReport < Prawn::Document
  def initialize
    super(:skip_page_creation => true)
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options = {})
    raise 'You must to provide a test option' if options[:order].blank?
    order_presenter = OrderPresenter.new(options[:order], nil)
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

    move_cursor_to 590
    text_box order_presenter.seller_presenter.name, :at => [370, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit
  end
end
