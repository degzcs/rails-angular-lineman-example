# Draw application shipment authorization and/or
class Royalty::DrawPdf < Prawn::Document
  attr_accessor :base_file, :order_presenters, :user_presenter

  def initialize(options = {})
    super(skip_page_creation: true)
    @response = {}
    @response[:success] = false
    @response[:errors] = []
  end

  def call(options = {})
    validate_options(options)
    @order_presenters = order_presenters_from(options[:orders])
    @user_presenter = ::UserPresenter.new(options[:current_user], nil)
    @base_file = options[:base_file] || File.open(File.join(Rails.root, 'vendor','pdfs','regalias.pdf'))
    begin
      draw_file!(
        user_presenter,
        order_presenters,
        options[:mineral_presentation],
        options[:royalty_period],
        options[:royalty_year],
        options[:date],
        options[:signature_picture]
        )
      @response[:success] = true
    # rescue => exception
    #   @response[:success] = false
    #   @response[:errors] << exception.message
    end
    @response
  end

  def file
    self
  end

  def draw_file!(user_presenter, order_presenters, mineral_presentation, royalty_period, royalty_year, date, signature_picture)
    start_new_page({ :template => "#{base_file.path}", :template_page => 1 })
    font_size 8

    #
    # Company section
    #
    company = user_presenter.company
    move_cursor_to 680
    text_box company.name, :at => [10, cursor + 30], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box 'X', :at => [360, cursor + 42 ], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box company.nit_number, :at => [360, cursor + 30], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box "#{ company.city.name }, #{ company.state.name }", :at => [10, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box company.address, :at => [200, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box company.phone_number, :at => [295, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box company.email, :at => [380, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    #
    # Mineral section
    #
    move_cursor_to 625
    text_box 'Metal Precioso', :at => [10, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box mineral_presentation, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    #
    # Production mineral section
    #

    #
    # Concept section
    #
    move_cursor_to 512
    text_box 'X', :at => [15, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    #
    # Period section
    #
    move_cursor_to 455
    case royalty_period
      when 1
        text_box 'XXX', :at => [55, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      when 2
        text_box 'XXX', :at => [160, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      when 3
        text_box 'XXX', :at => [270, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
      when 4
        text_box 'XXX', :at => [380, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    end
    text_box royalty_year, :at => [460, cursor + 5], :width => 300, :height => 15, :overflow => :shrink_to_fit

    #
    # Payment of royalities section
    #
    move_cursor_to 350
    text_box 'ORO', :at => [40, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box '52', :at => [125, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box 'Gramos', :at => [165, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box '88.87463', :at => [225, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit

    text_box 'Gramos', :at => [300, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box '4', :at => [370, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box '181.000', :at => [440, cursor + 50], :width => 300, :height => 15, :overflow => :shrink_to_fit

    text_box 'Jose Gonzales', :at => [50, cursor + 15], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box '181.000', :at => [440, cursor + 15], :width => 300, :height => 15, :overflow => :shrink_to_fit

    #
    # Destination section
    #
    move_cursor_to 300
    text_box 'Kaloti Metales', :at => [40, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box 'Str 18 # 13 - 123', :at => [225, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box 'Miami', :at => [360, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    text_box '52 gr.', :at => [455, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    #
    # Signature section
    #
    service = ::GenerateSignatureWithoutBackground.new
    signature_path = service.call(signature_picture)
    move_cursor_to 220
    image(signature_path, :at => [20, cursor + 10], :fit => [200, 80])
    text_box date.to_s, :at => [325, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
  end


  # @param orders [ Order ]
  # @return [ OrderPresenter ]
  def order_presenters_from(orders)
    orders.map { |order| ::OrderPresenter.new(order, nil) }
  end

  def validate_options(options)
    raise "You must to provide a orders option" if options[:orders].blank?
    raise "You must to provide a current_user option" if options[:current_user].blank?
    raise "You must to provide a mineral_presentation option" if options[:mineral_presentation].blank?
    raise "You must to provide a signature_picture option" if options[:signature_picture].blank?
    raise "You must to provide a royalty_period option" if options[:royalty_period].blank?
    raise "You must to provide a royalty_year option" if options[:royalty_year].blank?
    raise "You must to provide a date option" if options[:date].blank?
    raise "The current_user must to be the company legal representative" unless options[:current_user]&.profile&.legal_representative?
  end
end
