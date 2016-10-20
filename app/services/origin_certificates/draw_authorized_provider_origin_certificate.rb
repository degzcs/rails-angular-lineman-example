class OriginCertificates::DrawAuthorizedProviderOriginCertificate < Prawn::Document
  def initialize
    super(:skip_page_creation => true)
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options={})
    raise 'You must to provide a order option' if options[:order].blank?
    raise 'You must to provide a signature_picture option' if options[:signature_picture].blank?
    raise 'You must to provide a purchase option' if options[:date].blank?
    order_presenter = OrderPresenter.new(options[:order], nil)
    date_to_day = options[:date]
    signature_picture = options[:signature_picture]
    begin
      generate_certificate(order_presenter, signature_picture, date_to_day)
      @response[:success] = true
    rescue => exception
      @response[:success] = false
      @response[:errors] << exception.message
    end
    @response
  end

  # @return [ OriginCertificates::DrawAuthorizedProviderOriginCertificate ]
  def file
    self
  end

  # Generar certificado para barequeros y chatarreros
  def generate_certificate(order_presenter, signature_picture, date_to_day)
    file = File.open(File.join(Rails.root, 'vendor', 'pdfs', 'formato_certificado_origen_barequero_chatarrero.pdf'))
    start_new_page({:template => "#{file.path}", :template_page => 1})

    # complete information

    # header
    buyer_presenter = order_presenter.buyer_presenter

    move_cursor_to 590
    text_box buyer_presenter.city_name, :at => [370, cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 586

    text_box "#{date_to_day.day}", :at => [141, cursor], :width => 85
    text_box "#{date_to_day.month}", :at => [178, cursor], :width => 85
    text_box "#{date_to_day.year}", :at => [222, cursor], :width => 85

    # body producer
    seller_presenter = order_presenter.seller_presenter
    move_cursor_to 532
    case seller_presenter.provider_type.downcase
      when 'barequero'
        text_box 'X', :at => [386, cursor], :width => 85
      when 'chatarrero'
        text_box 'X', :at => [570, cursor], :width => 85
      else
        puts 'No se ha enviado  un parametro o este es incorrecto'
    end

    # Seller
    move_cursor_to 492
    text_box seller_presenter.name, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 462
    text_box seller_presenter.document_number, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 422
    text_box seller_presenter.state_name, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 362
    text_box seller_presenter.city_name, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    # Gold Batch
    gold_batch_presenter = order_presenter.gold_batch_presenter
    move_cursor_to 322
    text_box 'Oro', :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 294
    text_box gold_batch_presenter.formatted_fine_grams, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 267
    text_box 'Gramos', :at => [350, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    # Buyer

    move_cursor_to 219
    text_box buyer_presenter.company_name, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 185
    case 'nit'.downcase
      when 'nit'
        text_box 'X', :at => [320, cursor], :width => 40
      when 'document'
        text_box 'X', :at => [409, cursor], :width => 40
      when 'aliens_card'
        text_box 'X', :at => [510, cursor], :width => 40
      when 'rut'
        text_box 'X', :at => [579, cursor], :width => 40
      else
    end

    move_cursor_to 149
    text_box buyer_presenter.nit_number, :at => [300, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    move_cursor_to 112
    text_box buyer_presenter.rucom_number, :at => [350, cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 100
    signature = signature_picture.is_a?(Hash) ? OpenStruct.new(signature_picture) : signature_picture
    signature_path = generate_signature_without_background(signature)
    image(signature_path, :at => [400, cursor], :fit => [500,60])
  end

  # @param signature [ OpenStruct ] or Tempfile obejct
  # @return [ String ] with the image path converted, it means the image path without background.
  def generate_signature_without_background(signature)
    signature_file = File.read(signature.tempfile.path)
    folder_config = define_temporal_dir_and_file
    create_temporal_folder(folder_config.temporal_folder_path)
    File.write(folder_config.income_image_path, signature_file)
    was_convert = remove_background_for(folder_config.income_image_path, folder_config.outcome_image_path)
    was_convert ? folder_config.outcome_image_path : raise('This image cannot be removed its background!!!')
  end

  # @param income_image_path [ String ]
  # @param outcome_image_path [ String ]
  # @return [ Boolean ] truen when the command runs perfectly and false in other cases.
  def remove_background_for(income_image_path, outcome_image_path)
    system "convert #{ income_image_path } -fill none -fuzz 1% -draw 'matte 0,0 floodfill' -flop  -draw 'matte 0,0 floodfill' -flop #{ outcome_image_path }"
  end

  # @param folder_path [ String ] where the files will be saved temporarily
  # @return [ Boolean ]
  def create_temporal_folder(folder_path)
    system <<-COMMAND
      mkdir -p #{folder_path} && cd #{folder_path}
    COMMAND
  end

  # @params option [ Hash ]
  # @return [ Struct Object ] with the :temporal_folder_path, :income_image_path, :outcome_image_path
  def define_temporal_dir_and_file(options={})
    timestamp = options[:timestamp] || Time.now.to_i
    filename = options[:filename] || 'signature'
    temporal_folder_path = "#{ Rails.root }/tmp/signatures/#{ timestamp }"
    income_image_path = "#{ temporal_folder_path }/#{ filename }.jpg"
    outcome_image_path = "#{ temporal_folder_path }/#{ filename }.png"
    tmp = Struct.new(:temporal_folder_path, :income_image_path, :outcome_image_path)
    tmp.new(temporal_folder_path, income_image_path, outcome_image_path)
  end
end
