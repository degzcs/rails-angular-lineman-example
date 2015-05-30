require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/prawn_outputter'


class PdfFile < Prawn::Document

  def initialize(values , date , type)
    super(:skip_page_creation => true)

    case type

      when 'purchase_report'
        generate_purchase_report(values,date)
      when 'b_c_certificate'
        generate_certificate_b_c(values , date)
      when 'e_m_certificate'
        generate_certificate_e_m(values , date )
      when 'c_c_certificate'
        generate_multiple_certificates_c_c(values,date)
      when 'p_b_certificate'
        generate_multiple_certificates_p_b(values,date)
      when 'sales_report'
        generate_multiple_sales_reports(values,date)
      else
    end



    #generate_multiple_certificates_p_b(values,date)



  end

  # Generar certificado para barequeros y chatarreros
  def generate_certificate_b_c(values , date)
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_barequero_chatarrero.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    # complete information

    # header
    move_cursor_to 590
    text_box "#{values[:city]}", :at => [370,cursor], :width => 250, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 586
    text_box "#{date.day}", :at => [141,cursor] , :width => 85
    text_box "#{date.month}", :at => [178,cursor] , :width => 85
    text_box "#{date.year}" , :at => [222,cursor], :width => 85


    #body producer
    move_cursor_to 532
    case   values[:provider][:type].downcase
      when 'barequero'
        text_box "X", :at => [386,cursor] , :width => 85
      when 'chatarrero'
        text_box "X", :at => [570,cursor] , :width => 85
      else
        puts 'No se ha enviado  un parametro o este es incorrecto'
    end

    move_cursor_to 492
    text_box "#{values[:provider][:name]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 462
    text_box "#{values[:provider][:document_number]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 422
    text_box "#{values[:provider][:state]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 362
    text_box "#{values[:provider][:city]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 322
    text_box "#{values[:mineral][:type]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 294
    text_box "#{values[:mineral][:amount]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 267
    text_box "#{values[:mineral][:measure_unit]}" , :at => [350,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit

    #body buyer

    move_cursor_to 219
    text_box "#{values[:buyer][:company_name]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 185
    case values[:buyer][:document_type].downcase
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
    text_box "#{values[:buyer][:document_number]}" , :at => [300,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
    move_cursor_to 112
    text_box "#{values[:buyer][:rucom_record]}" , :at => [350,cursor] , :width => 300, :height => 15 , :overflow => :shrink_to_fit
  end

  # Generar certificado explotador minero autorizado
  def generate_certificate_e_m(values , date )
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_explotador_minero_autorizado.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    #complete information

    #header
    #move_down 190
    move_cursor_to 740
    text_box "#{values[:certificate_number]}", :at => [416,cursor], :width => 190 , :height => 15 , :overflow => :shrink_to_fit
    #move_down 5
    move_cursor_to 735
    text_box "#{date.day}", :at => [141,cursor] , :width => 85
    text_box "#{date.month}", :at => [175,cursor] , :width => 85
    text_box "#{date.year}" , :at => [200,cursor], :width => 85

    #body mining operator
    #move_down 42
    move_cursor_to 692
    case values[:provider][:type].downcase
      when 'titular'
        text_box "X" , :at => [361,cursor] , :width => 150
      when 'legalization_applicant'
        move_down 32
        text_box "X" , :at => [361,cursor] , :width => 150
      when 'are_beneficiary'
        text_box "X" , :at => [579,cursor] , :width => 150
      when 'formalization_subcontract'
        move_down 32
        text_box "X" , :at => [578,cursor] , :width => 150
      else
    end
    #move_down 40
    move_cursor_to 621
    text_box "#{values[:provider][:rucom_record]}" , :at => [290,cursor] , :width => 310, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 591
    #move_down 30
    text_box "#{values[:provider][:company_name]}" , :at => [290,cursor] , :width => 310, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 554
    #move_down 36
    case  values[:provider][:document_type].downcase
      when 'nit'
        text_box "X" , :at => [288,cursor] , :width => 150
      when 'document'
        text_box "X" , :at => [371,cursor] , :width => 150
      when 'aliens_card'
        text_box "X" , :at => [481,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [578,cursor] , :width => 150
      else
    end
    #move_down 45
    move_cursor_to 509
    text_box "#{values[:provider][:document_number]}" , :at => [290,cursor] , :width => 310, :overflow => :shrink_to_fit
    move_cursor_to 468
    #move_down 40
    text_box "#{values[:mineral][:state]}" , :at => [290,cursor] , :width => 310 , :height => 40 , :leading => 15 , :overflow => :shrink_to_fit
    move_cursor_to 418
    #move_down 50
    text_box "#{values[:mineral][:city]}" , :at => [290,cursor] , :width => 310, :height => 40 , :leading => 15 , :overflow => :shrink_to_fit
    move_cursor_to 367
    #move_down 50
    text_box "#{values[:mineral][:type]}" , :at => [290,cursor] , :width => 310 , :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 330
    #move_down 40
    text_box "#{values[:mineral][:amount]}" , :at => [290,cursor] , :width => 310, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 304
    #move_down 25
    text_box "#{values[:mineral][:measure_unit]}" , :at => [290,cursor] , :width => 310, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 249
    #move_down 55
    text_box "#{values[:buyer][:company_name]}" , :at => [290,cursor] , :width => 310, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 216
    #move_down 33
    case  values[:buyer][:document_type].downcase
      when 'nit'
        text_box "X" , :at => [276,cursor] , :width => 150
      when 'document'
        text_box "X" , :at => [373,cursor] , :width => 150
      when 'aliens_card'
        text_box "X" , :at => [497,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [585,cursor] , :width => 150
      else
    end
    #move_down 36
    move_cursor_to 180
    case values[:buyer][:type].downcase
      when 'trader'
        text_box "X" , :at => [380,cursor] , :width => 150
      when 'consumer'
        text_box "X" , :at => [548,cursor] , :width => 150
      else
    end
    #move_down 36
    move_cursor_to 144
    text_box "#{values[:buyer][:document_number]}" , :at => [290,cursor] , :width => 310, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 110
    #move_down 35
    text_box "#{values[:buyer][:rucom_record]}" , :at => [300,cursor] , :width => 280, :height => 15, :overflow => :shrink_to_fit

  end


  # Generar multiples certificados para plantas de beneficio

  def generate_multiple_certificates_p_b(values , date)

    values[:mining_operators].each_slice(7) do |mining_operator_group|
      generate_certificate_p_b(values , mining_operator_group , date)
    end

  end


  # Generar certificado para plantas de beneficio
  def generate_certificate_p_b(values, mining_operator_group , date )
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_plantas_beneficio.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    #header
    #move_down 140
    move_cursor_to 710
    text_box "#{values[:certificate_number]}", :at => [750,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 703
    text_box "#{date.day}", :at => [240,cursor] , :width => 85
    text_box "#{date.month}", :at => [345,cursor] , :width => 85
    text_box "#{date.year}" , :at => [430,cursor], :width => 85

    move_cursor_to 628
    text_box "#{values[:provider][:name]}", :at => [750,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 603
    text_box "#{values[:provider][:rucom_record]}", :at => [780 ,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 575
    case  values[:provider][:document_type].downcase
      when 'nit'
        text_box "X" , :at => [775,cursor] , :width => 150
      when 'document'
        text_box "X" , :at => [880,cursor] , :width => 150
      when 'aliens_card'
        text_box "X" , :at => [1050,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [1100,cursor] , :width => 150
      else
    end
    move_cursor_to 547
    text_box "#{values[:provider][:document_number]}", :at => [750,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit

    # dynamic  information about explotadores mineros autorizados

    move_cursor_to 465
    mining_operator_group.each do |operator|

     case operator[:type]
       when 'titular'
         text_box "X" , :at => [82,cursor] , :width => 80
       when 'are_beneficiary'
         text_box "X" , :at => [170,cursor] , :width => 80
       when 'legalization_applicant'
         text_box "X" , :at => [267,cursor] , :width => 80
       when 'formalization_subcontract'
         text_box "X" , :at => [375,cursor] , :width => 80
     end
      move_down 28
    end


    move_cursor_to 470
    mining_operator_group.each do |operator|
      text_box "#{operator[:origin_certificate_number]}", :at => [405,cursor], :width => 80, :height => 15, :overflow => :shrink_to_fit
      text_box "#{operator[:name]}", :at => [500,cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit
      text_box "#{operator[:document_type]}", :at => [740,cursor], :width => 80, :height => 15, :overflow => :shrink_to_fit
      text_box "#{operator[:document_number]}", :at => [825,cursor], :width => 90, :height => 15, :overflow => :shrink_to_fit
      text_box "#{operator[:mineral_type]}", :at => [920,cursor], :width => 85, :height => 15, :overflow => :shrink_to_fit
      text_box "#{operator[:amount]}", :at => [1010,cursor], :width => 56, :height => 15, :overflow => :shrink_to_fit
      text_box "#{operator[:measure_unit]}", :at => [1070,cursor], :width => 70, :height => 15, :overflow => :shrink_to_fit
      move_down 28
    end




    # body buyer

    move_cursor_to 225
    text_box "#{values[:total_amount]}", :at => [750,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 200
    text_box "#{values[:buyer][:company_name]}", :at => [750,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 167  #32
    case values[:buyer][:document_type].downcase
      when 'nit'
        text_box "X" , :at => [775,cursor] , :width => 150
      when 'document'
        text_box "X" , :at => [880,cursor] , :width => 150
      when 'aliens_card'
        text_box "X" , :at => [1050,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [1100,cursor] , :width => 150
      else
    end
    move_cursor_to 137
    text_box "#{values[:buyer][:document_number]}", :at => [750,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    move_cursor_to 109
    text_box "#{values[:buyer][:rucom_record]}", :at => [780,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit


  end


  # Generar multiples certificados para plantas de beneficio

  def generate_multiple_certificates_c_c(values , date)

    values[:invoices].each_slice(17) do |invoices_group|
      generate_certificate_c_c(values , invoices_group , date)
    end

  end




  # Generar certificado casas compraventa
  def generate_certificate_c_c(values , invoices_group , date )
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_casas_compraventa.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    #header
    #move_down 140
    move_cursor_to 585
    text_box "#{values[:certificate_number]}", :at => [755,cursor], :width => 270, :height => 15, :overflow => :shrink_to_fit
    text_box "#{values[:city][:name].capitalize}" , :at => [385 ,cursor] , :width => 200, :height => 15, :overflow => :shrink_to_fit
    #move_down 7
    move_cursor_to 577
    text_box "#{date.day}", :at => [150 , cursor] , :width => 85
    text_box "#{date.month}", :at => [184 , cursor] , :width => 85
    text_box "#{date.year}" , :at => [210 , cursor], :width => 85

    # header casas de compra y venta
    move_cursor_to 517
    text_box "#{values[:provider][:company_name]}", :at => [260,cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit

    #move_down 34
    move_cursor_to 483

    case  values[:provider][:document_type].downcase
      when 'nit'
        text_box "X" , :at => [341 , cursor] , :width => 150
      when 'document'
        text_box "X" , :at => [439,cursor] , :width => 150
      when 'aliens_card'
        move_down 23
        text_box "X" , :at => [341,cursor] , :width => 150
      when 'rut'
        move_down 25
        text_box "X" , :at => [439,cursor] , :width => 150
      else
    end

    move_cursor_to 428
    text_box "#{values[:provider][:document_number]}", :at => [260,cursor], :width => 200, :height => 15, :overflow => :shrink_to_fit

    # header comprador

    move_cursor_to 515
    text_box "#{values[:buyer][:company_name]}", :at => [715,cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit

    #move_down 34
    move_cursor_to 484
    case values[:buyer][:document_type].downcase
      when 'nit'
        text_box "X" , :at => [717 , cursor] , :width => 150
      when 'document'
        text_box "X" , :at => [800,cursor] , :width => 150
      when 'aliens_card'
        text_box "X" , :at => [895,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [960,cursor] , :width => 150
      else
    end

    #move_down 30
    move_cursor_to 457
    text_box "#{values[:buyer][:document_number]}", :at => [705,cursor], :width => 300, :height => 15, :overflow => :shrink_to_fit
    #move_down 17
    move_cursor_to 437
    text_box "#{values[:buyer][:rucom_record]}", :at => [750,cursor], :width => 250, :height => 15, :overflow => :shrink_to_fit
    #move_down 17
    #move_cursor_to 448
    # text_box "#{values[:buyer][:cp]}", :at => [710,cursor], :width => 300


    #body

    move_cursor_to 344
    invoices_group.each do |invoice|
      puts invoice[:date]
      text_box "#{invoice[:number]}", :at => [80,cursor], :width => 240, :height => 14, :overflow => :shrink_to_fit
      text_box "#{invoice[:date].to_date.day}", :at => [345,cursor], :width => 70, :height => 14, :overflow => :shrink_to_fit
      text_box "#{invoice[:date].to_date.month}", :at => [392,cursor], :width => 70, :height => 14, :overflow => :shrink_to_fit
      text_box "#{invoice[:date].to_date.year}", :at => [435,cursor], :width => 70, :height => 14, :overflow => :shrink_to_fit
      text_box "#{invoice[:description]}", :at => [480,cursor], :width => 250 , :height => 14, :overflow => :shrink_to_fit
      text_box "#{invoice[:amount]}", :at => [790,cursor], :width => 190, :height => 14, :overflow => :shrink_to_fit
      move_down 15
    end
  end

  # Generar certificado de compra
  def generate_purchase_report(values,date)
    file = File.open(File.join(Rails.root, 'vendor','pdfs','reporte_de_compra.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    # header
    #move_down 60
    move_cursor_to 775
    text_box "#{date.year} / #{date.month} / #{date.day} ", :at => [420,cursor] , :width => 80
    move_cursor_to 715
    barcode = Barby::EAN13.new(values[:purchase][:code])
    outputter = Barby::PrawnOutputter.new(barcode)
    outputter.annotate_pdf(self,options = {x:45 , y:cursor})
    font ("Courier") do
      text_box "#{values[:purchase][:code]}" , :at => [45 , cursor] , :width => 240
    end
    #move_down 13
    move_cursor_to 702
    text_box "#{date.hour}:#{date.min}:#{date.sec}" , :at => [420,757], :width => 80

    #provider
    move_cursor_to 666
    text_box "#{values[:provider][:company_name]}", :at => [400,cursor], :width => 150 , :size => 10 , :height =>  10
    #move_down 16
    move_cursor_to 648
    text_box "#{values[:provider][:nit]}", :at => [400,cursor], :width => 150, :size => 10 , :height =>  10
    move_cursor_to 629
    text_box "#{values[:provider][:name]}", :at => [400,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 611
    text_box "#{values[:provider][:document_number]}", :at => [400,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 593
    text_box "#{values[:provider][:rucom_record]}", :at => [400,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 575
    text_box "#{values[:provider][:address]}", :at => [400,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 557
    text_box "#{values[:provider][:phone]}", :at => [400,cursor], :width => 150, :size => 10, :height =>  10

    #buyer
    move_cursor_to 666
    text_box "#{values[:buyer][:company_name]}", :at => [130,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 650
    text_box "#{values[:buyer][:nit]}", :at => [130,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 630
    text_box "#{values[:buyer][:rucom_record]}", :at => [130,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 612
    text_box "#{values[:buyer][:first_name]}", :at => [130,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 593
    text_box "#{values[:buyer][:office]}", :at => [130,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 575
    text_box "#{values[:buyer][:address]}", :at => [130,cursor], :width => 150, :size => 10, :height =>  10
    move_cursor_to 557
    text_box "#{values[:buyer][:phone]}", :at => [130,cursor], :width => 150, :size => 10, :height =>  10


    if values[:gold_batch][:castellanos][:quantity] != 0
      move_cursor_to 485
      text_box "#{values[:gold_batch][:castellanos][:quantity].round(2)}" , :at => [355 , cursor] , :width => 100
      # text_box "#{values[:gold_batch][:castellanos][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    if values[:gold_batch][:tomines][:quantity] != 0
      move_cursor_to 466
      text_box "#{values[:gold_batch][:tomines][:quantity].round(2)}" , :at => [355 , cursor] , :width => 100
      # text_box "#{values[:gold_batch][:tomines][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    if values[:gold_batch][:riales][:quantity] != 0
      move_cursor_to 448
      text_box "#{values[:gold_batch][:riales][:quantity].round(2)}" , :at => [355 , cursor] , :width => 100
      # text_box "#{values[:gold_batch][:riales][:grams]} grs", :at => [480 , cursor], :width => 100
    end

    # if values[:gold_batch][:granos][:quantity] != 0
    #   move_cursor_to 345
    #   text_box "#{values[:gold_batch][:granos][:quantity].round(2)}" , :at => [280 , cursor] , :width => 100
    #   text_box "#{values[:gold_batch][:granos][:unit_value]}", :at => [400 , cursor], :width => 100
    # end

    move_cursor_to 412
    text_box "#{values[:gold_batch][:total_grams].round(2)} grs" , :at => [300 , cursor] , :width => 150 , :size => 10 , :height =>  10
    move_cursor_to 394
    text_box "#{values[:gold_batch][:grade]}" , :at => [300 , cursor] , :width => 150 , :size => 10 , :height =>  10

    move_cursor_to 375
    text_box "#{values[:gold_batch][:total_fine_grams].round(2)} grs" , :at => [300 , cursor] , :width => 150 , :size => 10 , :height =>  10
    move_cursor_to 357
    text_box "#{values[:purchase][:price].round(2)} pesos" , :at => [300 , cursor] , :width => 150 , :size => 10 , :height =>  10
    move_cursor_to 339
    text_box "#{values[:purchase][:fine_gram_unit_price].round(2)} pesos" , :at => [300 , cursor] , :width => 150 , :size => 10 , :height =>  10

    # 
    # move_cursor_to 105
    # text_box "#{values[:purchase][:code]}" , :at => [70 , cursor] , :width => 150

  end


  def generate_multiple_sales_reports(values , date)

    counter = 1

    values[:batch].each_slice(10) do |gold_group|
      generate_sales_report(values , gold_group , date,counter)
      counter = counter + 1
    end

    # add certificates
    start_new_page
    text_box "Certificados Adjuntos" , :at => [60,1100] , width: 400 , size: 30

    file = File.open(File.join(Rails.root, 'public',values[:certificate_path]))
    reader = PDF::Reader.new(file)

    for page in 1..reader.page_count.to_i do
      start_new_page({:template => "#{file.path}" , :template_page => page})
    end

  end




  def generate_sales_report(values,gold_group,date,counter)

    file = File.open(File.join(Rails.root, 'vendor','pdfs','reporte_de_venta.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    # header
    #move_down 60
    move_cursor_to 1046
    text_box "#{date.year} / #{date.month} / #{date.day} ", :at => [420,cursor] , :width => 80

    move_cursor_to 1028
    text_box "#{date.hour}:#{date.min}:#{date.sec}" , :at => [420,cursor], :width => 80

    move_cursor_to 1010
    text_box "#{counter}" , :at => [420,cursor] , :width => 80

    move_cursor_to 980
    barcode = Barby::EAN13.new('770000120040')
    outputter = Barby::PrawnOutputter.new(barcode)
    outputter.annotate_pdf(self,options = {x:45 , y:cursor})
    move_cursor_to 978
    font ("Courier") do
      text_box "#{values[:purchase][:code]}" , :at => [45 , cursor] , :width => 240
    end
    #buyer
    move_cursor_to 919
    text_box "#{values[:buyer][:social]}", :at => [115,cursor], :width => 170 , :size => 10 , :height =>  10
    move_cursor_to 900
    text_box "#{values[:buyer][:name]}", :at => [115,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 882
    text_box "#{values[:buyer][:type]}", :at => [115,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 865
    text_box "#{values[:buyer][:identification_number]}", :at => [115,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 846
    text_box "#{values[:buyer][:nit]}", :at => [115,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 829
    text_box "#{values[:buyer][:rucom]}", :at => [115,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 810
    text_box "#{values[:buyer][:address]}", :at => [115,cursor], :width => 170 , :size => 10, :height =>  10
    move_cursor_to 792
    text_box "#{values[:buyer][:email]}", :at => [115,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 774
    text_box "#{values[:buyer][:phone]}", :at => [115,cursor], :width => 170, :size => 10, :height =>  10


    #provider
    move_cursor_to 919
    text_box "#{values[:provider][:social]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 900
    text_box "#{values[:provider][:name]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 882
    text_box "#{values[:provider][:type]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 865
    text_box "#{values[:provider][:identification_number]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 846
    text_box "#{values[:provider][:nit]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 829
    text_box "#{values[:provider][:rucom]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 810
    text_box "#{values[:provider][:address]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 792
    text_box "#{values[:provider][:email]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10
    move_cursor_to 774
    text_box "#{values[:provider][:phone]}", :at => [370,cursor], :width => 170, :size => 10, :height =>  10


    #transportador
    move_cursor_to 720
    text_box "#{values[:carrier][:first_name]}", :at => [115,cursor], :width => 170
    text_box "#{values[:carrier][:phone]}", :at => [370,cursor], :width => 170
    move_cursor_to 702
    text_box "#{values[:carrier][:last_name]}", :at => [115,cursor], :width => 170
    text_box "#{values[:carrier][:address]}", :at => [370,cursor], :width => 170
    move_cursor_to 682
    text_box "#{values[:carrier][:identification_number]}", :at => [115,cursor], :width => 170
    text_box "#{values[:carrier][:company]}", :at => [370,cursor], :width => 170
    move_cursor_to 665
    text_box "#{values[:carrier][:nit]}", :at => [115,cursor], :width => 170

    #lotes seleccionados

    move_cursor_to 585
    gold_group.each do |gold|
      text_box "#{gold[:id_purchase]}", :at => [50,cursor], :width => 70 , :size => 10, :height =>  10
      text_box "#{gold[:id_provider]}", :at => [130,cursor], :width => 70 , :size => 10, :height =>  10
      text_box "#{gold[:social]}", :at => [233,cursor], :width => 120 , :size => 10, :height =>  10
      text_box "#{gold[:certificate_number]}", :at => [392,cursor], :width => 90 , :size => 10, :height =>  10
      text_box "#{gold[:rucom]}", :at => [487,cursor], :width => 90 , :size => 10, :height =>  10
      text_box "#{gold[:fine_grams]}", :at => [565,cursor], :width => 90, :size => 10, :height =>  10
      move_down 25
    end

    # numero total de lotes

    move_cursor_to 285
    text_box "#{values[:purchase][:fine_grams]}", :at => [420,cursor], :width => 90 , :size => 10 , :height =>  10
    move_cursor_to 267
    text_box "#{values[:purchase][:grams]}", :at => [420,cursor], :width => 90 , :size => 10 , :height =>  10
    move_cursor_to 248
    text_box "#{values[:purchase][:law]}", :at => [420,cursor], :width => 90 , :size => 10, :height =>  10
    move_cursor_to 229
    text_box "#{values[:purchase][:price]}", :at => [420,cursor], :width => 90 , :size => 10, :height =>  10
  end

end
