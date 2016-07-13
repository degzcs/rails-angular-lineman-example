class OriginCertificates::DrawAuthorizedProviderOriginCertificate < Prawn::Document

  def initialize
    super(:skip_page_creation => true)
    @response = {}
    @response[:errors] = []
  end

  # @return [ Hash ] with the success or errors
  def call(options={})
    raise 'You must to provide a purchase option' if options[:purchase].blank?
    raise 'You must to provide a signature_picture option' if options[:signature_picture].blank?
    purchase = options[:purchase]
    signature_picture = options[:signature_picture]
    begin
      generate_certificate(purchase, signature_picture)
      @response[:success] = true
    rescue => e
      @response[:success] = false
      @response[:errors] = e
    end
    @response
  end

  # @return [ OriginCertificates::DrawAuthorizedProviderOriginCertificate ]
  def file
    self
  end

  # Generar certificado para barequeros y chatarreros
  def generate_certificate(purchase, signature_picture)
    date = Date.today
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_barequero_chatarrero.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    # complete information

    # header
    move_cursor_to 590
    text_box purchase.user.office.city.name, :at => [370,cursor], :width => 250, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 586

    text_box "#{date.day}", :at => [141,cursor] , :width => 85
    text_box "#{date.month}", :at => [178,cursor] , :width => 85
    text_box "#{date.year}" , :at => [222,cursor], :width => 85

     #body producer
    move_cursor_to 532
    case   purchase.seller.rucom.provider_type.downcase
      when 'barequero'
        text_box "X", :at => [386,cursor] , :width => 85
      when 'chatarrero'
        text_box "X", :at => [570,cursor] , :width => 85
      else
        puts 'No se ha enviado  un parametro o este es incorrecto'
    end

    purchase_seller_profile_name = purchase.seller.profile.first_name + " " +  purchase.seller.profile.last_name

    move_cursor_to 492
    text_box purchase_seller_profile_name , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    move_cursor_to 462
    text_box purchase.seller.profile.document_number , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    move_cursor_to 422
    text_box purchase.seller.profile.city.state.name , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    move_cursor_to 362
    text_box purchase.seller.profile.city.name , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit


    move_cursor_to 322
    text_box "Oro" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit


     move_cursor_to 294
     text_box purchase.gold_batch.fine_grams.to_s , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    move_cursor_to 267
    text_box "Gramos" , :at => [350,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    #body buyer

    move_cursor_to 219
    text_box purchase.user.company.name , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    move_cursor_to 185
    case "nit".downcase
      when 'nit'
        text_box "X" , :at => [320,cursor] , :width => 40
      when 'document'
        text_box "X" , :at => [409,cursor] , :width => 40
      when 'aliens_card'
        text_box "X" , :at => [510,cursor] , :width => 40
      when 'rut'
        text_box "X" , :at => [579,cursor] , :width => 40
      else
    end

    move_cursor_to 149
    text_box purchase.user.company.nit_number , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    move_cursor_to 112
    text_box purchase.user.company.rucom.num_rucom , :at => [350,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 86
    signature = image(signature_picture, :at => [280,cursor], :fit => [200,100])
  end
end