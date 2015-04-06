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
            #values = { certificate_number: '1292924838434', mining_operator: {type: 'subcontrato',  code: '110043843848393' , name: 'mineros de boyaca' , identification_type: 'rut' , identification_number: '129292294030302'}, mineral: { state: 'cauca' , city: 'popayan' , mineral: 'Oro' , quantity: 25000 , unit: 'mg' } ,purchaser:{ name: 'compradores oro ltda' , identification_type: 'nit', purchaser_type: 'consumidor' , identification_number: '1018458483' , rucom: '10139348989'} }
            #date = Date.today


        # values certificado origen planta beneficio
          #trader --> identification_type
            # nit
            # cedula de ciudadania
            # cedula de extrangeria
            # rut

          # purchaser --> identification_type
            #nit
            #cedula de ciudadania
            #cedula de extranjeria
            #rut


          #test data
=begin
           values = { certificate_number: '1292924838434',
                      trader: { rucom: '110043843848393' ,
                                name: 'mineros de boyaca' ,
                                identification_type: 'cedula de extranjeria',
                                identification_number: '129292294030302'},
                      purchaser:{ name: 'compradores oro ltda',
                                  identification_type: 'cedula de extranjeria',
                                  identification_number: '1018458483',
                                  rucom: '10139348989'},
                      mineral: { quantity: '200 mg'},
                      mining_operator: [{
                                         type: 'titular',
                                         certificate_code: '110043843848393',
                                         name: 'mineros de boyaca',
                                         identification_type: 'rut',
                                         identification_number: '129292294030302',
                                         mineral: 'Oro',
                                         quantity: '200',
                                         unit:'mg'},
                                        {
                                         type: 'beneficiario',
                                         certificate_code: '110043843848393-2',
                                         name: 'mineros de boyaca-2',
                                         identification_type: 'nit',
                                         identification_number: '129292294030302-2',
                                         mineral: 'Oro',
                                         quantity: '400',
                                         unit:'mg'},
                                        {
                                         type: 'solicitante',
                                         certificate_code: '110043843848393-3',
                                         name: 'mineros de boyaca-3',
                                         identification_type: 'cedula de ciudadania',
                                         identification_number: '129292294030302-3',
                                         mineral: 'Oro',
                                         quantity: '500',
                                         unit:'mg'
                                        },
                                        {
                                         type: 'subcontrato',
                                         certificate_code: '110043843848393-4',
                                         name: 'mineros de boyaca-4',
                                         identification_type: 'cedula de extranjeria',
                                         identification_number: '129292294030302-4',
                                         mineral: 'Oro',
                                         quantity: '600',
                                         unit:'mg'
                                        },
                                        {
                                            type: 'subcontrato',
                                            certificate_code: '110043843848393-4',
                                            name: 'mineros de boyaca-4',
                                            identification_type: 'cedula de extranjeria',
                                            identification_number: '129292294030302-4',
                                            mineral: 'Oro',
                                            quantity: '600',
                                            unit:'mg'
                                        },
                                        {
                                            type: 'titular',
                                            certificate_code: '110043843848393-4',
                                            name: 'mineros de boyaca-4',
                                            identification_type: 'cedula de extranjeria',
                                            identification_number: '129292294030302-4',
                                            mineral: 'Oro',
                                            quantity: '600',
                                            unit:'mg'
                                        },
                                        {
                                            type: 'beneficiario',
                                            certificate_code: '110043843848393-4',
                                            name: 'mineros de boyaca-4',
                                            identification_type: 'cedula de extranjeria',
                                            identification_number: '129292294030302-4',
                                            mineral: 'Oro',
                                            quantity: '600',
                                            unit:'mg'
                                        },
                                        {
                                            type: 'titular',
                                            certificate_code: '110043843848393-4',
                                            name: 'mineros de boyaca-9',
                                            identification_type: 'cedula de extranjeria',
                                            identification_number: '129292294030302-4',
                                            mineral: 'Oro',
                                            quantity: '600',
                                            unit:'mg'
                                        }
                                       ]
                    }




           date = Date.today
=end

        # values certificado origen casas compraventa

          # purchaser --> identification_type
          #nit
          #cedula de ciudadania
          #cedula de extranjeria
          #rut

          #invoices --> date
            # 2015-04-06

          #test data
=begin
           values = { certificate_number: '1292924838434',
                      city: 'popayan',
                      house: { name: 'mineros de boyaca' ,
                               identification_type: 'rut',
                               identification_number: '129292294030302'
                             },
                      purchaser:{ name: 'compradores oro ltda',
                                  identification_type: 'rut',
                                  identification_number: '1018458483',
                                  rucom: '10139348989',
                                  cp: '1393902020202'
                                },
                      invoices: [{
                                     number: '1101010101010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1102010101010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010104010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010101060101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010101010801',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010101010191',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010101010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010101010101',
                                     date: Date.today.to_datetime,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010161010121',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101410102010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010101022220101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '1101010102010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                 },
                                 {
                                     number: '11010134322010101',
                                     date: Date.today.to_date,
                                     description: 'descripccion del documento',
                                     quantity: '500mg'
                                }
                      ]
                    }
           date = Date.today
=end

        # values reporte de compra trazoro

        # purchase --> type
          #castellanos
          #tamines
          #reales
          #granos

        #test data
        values = { provider: { rucom: '1010101949482',
                               identification_type: 'rut',
                               name: 'Esteban Ceron',
                               email: 'restebance@trazoro.com',
                               identification_number: '129292294030302',
                               phone: '10303039503',
                               address: 'Carrera 9N #67N - 156'
                             },
                   purchases: [ { type: 'castellanos',
                                 quantity: 20,
                                 unit_value: 2500000
                               },
                               {
                                 type: 'tamines',
                                 quantity: 200,
                                 unit_value: 2000000
                               },
                               {
                                 type: 'reales',
                                 quantity: 5000,
                                 unit_value: 2000000
                               },
                               {
                                type: 'granos',
                                quantity: 600000,
                                unit_value: 404003030303
                               }
                               ],
                   total: 20202020202,
                   law: 1000,
                   weight: 1000000,
                   code: '11jddj29292929292'
                  }
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