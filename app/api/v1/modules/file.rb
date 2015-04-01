module V1
  module Modules
    class File <  Grape::API

      content_type :pdf , 'application/pdf'
      format :pdf

      get 'download_file' do

        #values certificado de origen barequero chatarrero

          # producer_entity -->  producer_type
            # barequero
            # chatarrero

          # purchaser_entity --> identification_type
            # cedula de ciudadania
            # cedula de extrangeria
            # nit
            # rut
          # test data
            #values = { city: 'Popayan', producer:{ name: 'Francisco Fuentes' , document_number: '1061742777' , city: 'piendamo' , state: 'cauca' , producer_type: 'chatarrero' } , mineral:{ mineral: 'Oro' , quantity: 200 , unit: 'mg'} , purchaser:{ name: 'compradores oro ltda' , identification_type: 'rut' , identification_number: '1018458483' , rucom: '10139348989'} }
            #date = Date.today  #fecha


        #values certificado de origen explotador minero
          #mining_operator --> identification_type
            # cedula de ciudadania
            # cedula de extrangeria
            # nit
            # rut

          #mining_operator --> type
            # titular minero  --> titular
            # solicitante de legalizacion --> solicitante
            # beneficiario area de reserva especial --> beneficiario
            # subcontrato de formalizacion  --> subcontrato

          #purchaser --> type
            #comercializador
            #consumidor


          #test data
            values = { certificate_number: '1292924838434', mining_operator: {type: 'subcontrato',  code: '110043843848393' , name: 'mineros de boyaca' , identification_type: 'rut' , identification_number: '129292294030302'}, mineral: { state: 'cauca' , city: 'popayan' , mineral: 'Oro' , quantity: 25000 , unit: 'mg' } ,purchaser:{ name: 'compradores oro ltda' , identification_type: 'nit', purchaser_type: 'consumidor' , identification_number: '1018458483' , rucom: '10139348989'} }
            date = Date.today

        # generate pdf
          pdf = ::PdfFile.new(values , date)
          #puts pdf.render
          header['Content-Disposition'] = "attachment; filename=hola.pdf"
          env['api.format'] = :pdf
          body pdf.render
      end

    end
  end
end