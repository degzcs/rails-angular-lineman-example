class PdfFile < Prawn::Document

  def initialize(values , date)
    super()
    #generate_certificate_b_c(values , date)
    #generate_certificate_p_b(values , date )
    #generate_certificate_c_c
    generate_certificate_e_m(values , date )
  end

  # Generar certificado para barequeros y chatarreros
  def generate_certificate_b_c(values , date)
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_barequero_chatarrero.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    # complete information

    # header
    move_down 132
    text_box "#{values[:city]}", :at => [370,cursor], :width => 150
    move_down 3
    text_box "#{date.day}", :at => [141,cursor] , :width => 85
    text_box "#{date.month}", :at => [178,cursor] , :width => 85
    text_box "#{date.year}" , :at => [222,cursor], :width => 85


    #body producer

    move_down 51
    case   values[:producer][:producer_type]
      when 'barequero'
        text_box "X", :at => [386,cursor] , :width => 85
      when 'chatarrero'
        text_box "X", :at => [570,cursor] , :width => 85
      else
        puts 'No se ha enviado  un parametro o este es incorrecto'
    end

    move_down 40
    text_box "#{values[:producer][:name]}" , :at => [300,cursor] , :width => 150
    move_down 30
    text_box "#{values[:producer][:document_number]}" , :at => [300,cursor] , :width => 150
    move_down 40
    text_box "#{values[:producer][:state]}" , :at => [300,cursor] , :width => 150
    move_down 60
    text_box "#{values[:producer][:city]}" , :at => [300,cursor] , :width => 150
    move_down 40
    text_box "#{values[:mineral][:mineral]}" , :at => [300,cursor] , :width => 150
    move_down 30
    text_box "#{values[:mineral][:quantity]}" , :at => [300,cursor] , :width => 150
    move_down 25
    text_box "#{values[:mineral][:unit]}" , :at => [350,cursor] , :width => 150

    #body purchaser

    move_down 48
    text_box "#{values[:purchaser][:name]}" , :at => [300,cursor] , :width => 150
    move_down 36
    case values[:purchaser][:identification_type]
      when 'nit'
        text_box "X" , :at => [320,cursor] , :width => 150
      when 'cedula de ciudadania'
        text_box "X" , :at => [412,cursor] , :width => 150
      when 'cedula de extranjeria'
        text_box "X" , :at => [510,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [579,cursor] , :width => 150
      else
    end
    move_down 36
    text_box "#{values[:purchaser][:identification_number]}" , :at => [300,cursor] , :width => 150
    move_down 35
    text_box "#{values[:purchaser][:rucom]}" , :at => [350,cursor] , :width => 150
  end


  # Generar certificado para plantas de beneficio
  def generate_certificate_p_b
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_plantas_beneficio.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})
  end

  def generate_certificate_c_c
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_casas_compraventa.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})
  end

  def generate_certificate_e_m(values , date )
    file = File.open(File.join(Rails.root, 'vendor','pdfs','formato_certificado_origen_explotador_minero_autorizado.pdf'))
    start_new_page({:template => "#{file.path}" , :template_page => 1})

    #complete information

    #header
    move_down 190
    text_box "#{values[:certificate_number]}", :at => [420,cursor], :width => 150
    move_down 5
    text_box "#{date.day}", :at => [141,cursor] , :width => 85
    text_box "#{date.month}", :at => [175,cursor] , :width => 85
    text_box "#{date.year}" , :at => [200,cursor], :width => 85

    #body mining operator
    move_down 42
    case values[:mining_operator][:type]
      when 'titular'
        text_box "X" , :at => [360,cursor] , :width => 150
      when 'solicitante'
        move_down 32
        text_box "X" , :at => [360,cursor] , :width => 150
      when 'beneficiario'
        text_box "X" , :at => [579,cursor] , :width => 150
      when 'subcontrato'
        move_down 32
        text_box "X" , :at => [579,cursor] , :width => 150
      else
    end
    move_down 40
    text_box "#{values[:mining_operator][:code]}" , :at => [300,cursor] , :width => 150
    move_down 30
    text_box "#{values[:mining_operator][:name]}" , :at => [300,cursor] , :width => 150
    move_down 36
    case values[:mining_operator][:identification_type]
      when 'nit'
        text_box "X" , :at => [287,cursor] , :width => 150
      when 'cedula de ciudadania'
        text_box "X" , :at => [371,cursor] , :width => 150
      when 'cedula de extranjeria'
        text_box "X" , :at => [482,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [579,cursor] , :width => 150
      else
    end
    move_down 45
    text_box "#{values[:mining_operator][:identification_number]}" , :at => [300,cursor] , :width => 150
    move_down 40
    text_box "#{values[:mineral][:state]}" , :at => [300,cursor] , :width => 150
    move_down 50
    text_box "#{values[:mineral][:city]}" , :at => [300,cursor] , :width => 150
    move_down 50
    text_box "#{values[:mineral][:mineral]}" , :at => [300,cursor] , :width => 150
    move_down 40
    text_box "#{values[:mineral][:quantity]}" , :at => [300,cursor] , :width => 150
    move_down 25
    text_box "#{values[:mineral][:unit]}" , :at => [300,cursor] , :width => 150

    move_down 55
    text_box "#{values[:purchaser][:name]}" , :at => [300,cursor] , :width => 150
    move_down 34
    case values[:purchaser][:identification_type]
      when 'nit'
        text_box "X" , :at => [275,cursor] , :width => 150
      when 'cedula de ciudadania'
        text_box "X" , :at => [376,cursor] , :width => 150
      when 'cedula de extranjeria'
        text_box "X" , :at => [497,cursor] , :width => 150
      when 'rut'
        text_box "X" , :at => [585,cursor] , :width => 150
      else
    end
    move_down 36
    case values[:purchaser][:purchaser_type]
      when 'comercializador'
        text_box "X" , :at => [380,cursor] , :width => 150
      when 'consumidor'
        text_box "X" , :at => [547,cursor] , :width => 150
      else
    end
    move_down 36
    text_box "#{values[:purchaser][:identification_number]}" , :at => [300,cursor] , :width => 150
    move_down 35
    text_box "#{values[:purchaser][:rucom]}" , :at => [350,cursor] , :width => 150


  end

end