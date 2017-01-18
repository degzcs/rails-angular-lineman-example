class UiafReport::DrawUiafReport < Prawn::Document
  def initialize
    super(:skip_page_creation => true)
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options = {})
    raise 'You must to provide a test option' if options[:test].blank?
    test = options[:test]
    begin
      generate_uiaf_report(test)
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

  def generate_uiaf_report(test)
    file = File.open(File.join(Rails.root, 'vendor', 'pdfs', 'uiaf_report.pdf'))
    start_new_page({:template => "#{file.path}", :template_page => 1})

    move_cursor_to 590
    text_box test, :at => [370, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit
  end
end
