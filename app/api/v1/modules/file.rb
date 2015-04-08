module V1
  module Modules
    class File <  Grape::API

      before_validation do
       authenticate!
      end
=begin
      helpers do

        # params to generate a purchase report
        params :purchase_data do
          optional :purchase, type: Hash , desc: 'purchase_report_params' , documentation: {example: 'Rock'} do
            optional :provider, type: Hash do
              optional :rucom , type: String , desc: 'rucom_number' , documentation: {example: 'Rock'}
              optional :identification_type , type: String , desc: 'identification_type' , documentation: {example: 'Rock'}
              optional :name , type: String , desc: 'provider name' , documentation: {example: 'Rock'}
              optional :email , type: String , desc: 'provider email' , documentation: {example: 'Rock'}
              optional :identification_number , type: String , desc: 'provider identification number' , documentation: {example: 'Rock'}
              optional :phone , type: String , desc: 'provider phone' , documentation: {example: 'Rock'}
              optional :address , type: String , desc: 'provider address' , documentation: {example: 'Rock'}
            end
            optional :purchases , type: Array , desc: 'purchases' , documentation: {example: 'Rock'}
            optional :total , type: Integer , desc: 'purchase total' , documentation:{example: 'Rock'}
            optional :law , type: Integer , desc: 'purchase law' , documentation:{example: 'Rock'}
            optional :weight , type: Integer , desc: 'mineral weight' , documentation: {example: 'Rock'}
            optional :code , type: String , desc:'purchase code' , documentation: {example: 'Rock'}
          end

        end

        params :e_m_report do
          optional :e_m_data , type: Hash , desc: 'e_m_certificate' , documentation: {example: 'Rock'} do
            optional :certificate_number , type: String , desc: 'consecutive certificate number' , documentation: {example: 'Rock'}
            optional :mining_operator , type: Hash , desc: 'mining operator' , documentation: {example: 'Rock'} do
              optional :type , type: String , desc: 'type of mining operator' , documentation:{example: 'Rock'}
              optional :code , type: String , desc: 'code' , documentation:{example: 'Rock'}
              optional :name , type: String , desc: 'name' , documentation:{example: 'Rock'}
              optional :identification_type , type: String , desc: 'identification type' , documentation:{example: 'Rock'}
              optional :identification_number , type: String , desc: 'identification number' , documentation:{example: 'Rock'}
            end
            optional :mineral , type: Hash, desc: 'mineral' , documentation: {example: 'Rock'} do
              optional :state , type: String , desc: 'state (Cauca)' , documentation:{example: 'Rock'}
              optional :city , type: String , desc: 'city (popayán)' , documentation:{example: 'Rock'}
              optional :mineral , type: String , desc: 'mineral (oro)' , documentation:{example: 'Rock'}
              optional :quantity , type: Integer , desc: 'mineral quantity' , documentation:{example: 'Rock'}
              optional :unit , type: String  , desc: 'mineral quantity unit' , documentation:{example: 'Rock'}
            end
            optional :purchaser , type: Hash, desc: 'mineral' , documentation: {example: 'Rock'} do
              optional :name , type: String , desc: 'purchaser name' , documentation:{example: 'Rock'}
              optional :identification_type , type: String , desc: 'purchaser identification type' , documentation:{example: 'Rock'}
              optional :purchaser_type , type: String , desc: 'purchaser type' , documentation:{example: 'Rock'}
              optional :identification_number , type: String , desc: 'purchaser identification number' , documentation:{example: 'Rock'}
              optional :rucom , type: String , desc: 'purchaser rucom' , documentation:{example: 'Rock'}
            end
          end
        end

        params :p_b_report do
          optional :p_b_data , type: Hash , desc: 'p_b_certificate' , documentation: {example: 'Rock'} do
            optional :certificate_number , type: String , desc: 'consecutive certificate number' , documentation: {example: 'Rock'}
            optional :trader , type: Hash, desc: 'trader' , documentation: {example: 'Rock'} do
              optional :rucom , type: String , desc: 'trader rucom' , documentation:{example: 'Rock'}
              optional :name , type: String , desc: 'trader name' , documentation:{example: 'Rock'}
              optional :identification_type , type: String , desc: 'trader identification type' , documentation:{example: 'Rock'}
              optional :identification_number , type: String , desc: 'trader identification number' , documentation:{example: 'Rock'}
            end
            optional :purchaser , type: Hash , desc: 'purchaser' , documentation:{example: 'Rock'} do
              optional :name , type: String , desc: 'purchaser name' , documentation:{example: 'Rock'}
              optional :rucom , type: String , desc: 'purchaser rucom' , documentation:{example: 'Rock'}
              optional :identification_type , type: String , desc: 'purchaser identification type' , documentation:{example: 'Rock'}
              optional :identification_number , type: String , desc: 'purchaser identification number' , documentation:{example: 'Rock'}
            end
            optional :mineral , type: Hash , desc: 'mineral' , documentation:{example: 'Rock'} do
              optional :quantity , type: String , desc: 'mineral quantity' , documentation:{example: 'Rock'}
            end
            optional :mining_operator , type: Array , desc: 'mining operator' , documentation: {example: "[{ type: 'titular', certificate_code: '110043843848393', name: 'mineros de boyaca', identification_type: 'rut', identification_number: '129292294030302', mineral: 'Oro', quantity: '200', unit:'mg'}]"}
          end
        end

        params :c_c_report do
          optional :c_c_data , type: Hash , desc: 'c_c_certificate', documentation: {example: 'Rock'} do
            optional :certificate_number , type: String , desc: 'consecutive certificate number' , documentation: {example: 'Rock'}
            optional :city , type: String , desc: 'city' , documentation: {example: 'Rock'}
            optional :house , type: Hash, desc: 'house' , documentation: {example: 'Rock'} do
              optional :name , type: String , desc: 'house name' , documentation:{example: 'Rock'}
              optional :identification_type , type: String , desc: 'house identification type' , documentation:{example: 'Rock'}
              optional :identification_number , type: String , desc: 'house identification number' , documentation:{example: 'Rock'}
            end
            optional :purchaser , type: Hash, desc: 'purchaser' , documentation: {example: 'Rock'} do
              optional :name , type: String , desc: 'purchaser name' , documentation:{example: 'Rock'}
              optional :identification_type , type: String , desc: 'purchaser identification type' , documentation:{example: 'Rock'}
              optional :identification_number , type: String , desc: 'purchaser identification number' , documentation:{example: 'Rock'}
              optional :rucom , type: String , desc: 'purchaser rucom' , documentation:{example: 'Rock'}
              optional :cp , type: String , desc: 'purchaser cp' , documentation:{example: 'Rock'}
            end
            optional :invoices , type: Array , desc: 'invoices' , documentation: {example: "[{ number: '1101010101010101', date: Date.today.to_date, description: 'descripccion del documento', quantity: '500mg'}]"}
          end
        end

        params :b_c_report do
          optional :b_c_data , type: Hash , desc: 'b_c_certificate' , documentation: {example: 'Rock'} do
            optional :city , type: String , desc: 'city' , documentation: {example: 'Rock'}
            optional :producer , type: Hash, desc: 'producer' , documentation: {example: 'Rock'} do
              optional :name , type: String , desc: 'producer name' , documentation:{example: 'Rock'}
              optional :document_number , type: String , desc: 'producer document number' , documentation:{example: 'Rock'}
              optional :city , type: String , desc: 'producer city' , documentation:{example: 'Rock'}
              optional :state , type: String , desc: 'producer state' , documentation:{example: 'Rock'}
              optional :producer_type , type: String , desc: 'producer type' , documentation:{example: 'Rock'}
            end
            optional :mineral , type: Hash, desc: 'mineral' , documentation: {example: 'Rock'} do
              optional :mineral , type: String , desc: 'mineral name' , documentation:{example: 'Rock'}
              optional :quantity , type: String , desc: 'mineral quantity' , documentation:{example: 'Rock'}
              optional :unit , type: String , desc: 'mineral quantity unit' , documentation:{example: 'Rock'}
            end
            optional :purchaser , type: Hash, desc: 'purchaser' , documentation: {example: 'Rock'} do
              optional :name , type: String , desc: 'purchaser name' , documentation:{example: 'Rock'}
              optional :identification_type , type: String , desc: 'identification type' , documentation:{example: 'Rock'}
              optional :identification_number , type: String , desc: 'identification number' , documentation:{example: 'Rock'}
              optional :rucom , type: String , desc: 'rucom' , documentation:{example: 'Rock'}
            end
          end
        end


      end
=end


      content_type :pdf , 'application/pdf'
      format :pdf

      resource :files do

        get 'download_e_m_certificate' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          #params do
          #requires :e_m_report ,type: Hash
          #end


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
          values = { certificate_number: '1292924838434',
                     mining_operator: {type: 'subcontrato',
                                       code: '110043843848393' ,
                                       name: 'mineros de boyaca' ,
                                       identification_type: 'rut' ,
                                       identification_number: '129292294030302'},
                     mineral: { state: 'cauca' ,
                                city: 'popayan' ,
                                mineral: 'Oro' ,
                                quantity: 25000 ,
                                unit: 'mg' } ,
                     purchaser:{ name: 'compradores oro ltda' ,
                                 identification_type: 'nit',
                                 purchaser_type: 'consumidor' ,
                                 identification_number: '1018458483' ,
                                 rucom: '10139348989'}
                    }

          date = Date.today

          #values = params[:e_m_report]
          pdf = ::PdfFile.new(values , date , 'e_m_certificate')
          #puts pdf.render
          header['Content-Disposition'] = "attachment; filename= certificate_explotadores_mineros_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render


        end

        get 'download_p_b_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          #params do
          #requires :p_b_report ,type: Hash
          #end

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

          #values = params[:p_b_report]
          pdf = ::PdfFile.new(values , date , 'p_b_certificate')
          #puts pdf.render
          header['Content-Disposition'] = "attachment; filename=certificado_plantas_beneficio_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end

        get 'download_c_c_report'  , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          #params do
          #requires :c_c_report ,type: Hash
          #end

          # values certificado origen casas compraventa

          # purchaser --> identification_type
          #nit
          #cedula de ciudadania
          #cedula de extranjeria
          #rut

          #invoices --> date
          # 2015-04-06

          #test data

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

          #values = params[:c_c_report]
          pdf = ::PdfFile.new(values , date , 'c_c_certificate')
          #puts pdf.render
          header['Content-Disposition'] = "attachment; filename=certificate_casas_compraventa_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end


        get 'download_b_c_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          #params do
          #requires :b_c_report ,type: Hash
          #end

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

          values = { city: 'Popayan',
                     producer:{ name: 'Francisco Fuentes',
                                document_number: '1061742777',
                                city: 'piendamo',
                                state: 'cauca',
                                producer_type: 'chatarrero' },
                     mineral:{ mineral: 'Oro',
                               quantity: 200 ,
                               unit: 'mg'} ,
                     purchaser:{ name: 'compradores oro ltda',
                                 identification_type: 'rut',
                                 identification_number: '1018458483',
                                 rucom: '10139348989'}
                     }
          date = Date.today  #fecha

          #values = params[:b_c_report]
          pdf = ::PdfFile.new(values , date , 'b_c_certificate')
          #puts pdf.render
          header['Content-Disposition'] = "attachment; filename=certificado_barequeros_chatarreros_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end



        post 'download_purchase_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          #params do
            #requires :purchase ,type: Hash
          #end

          # purchase --> type
          #castellanos
          #tamines
          #reales
          #granos
          # hash

          # values = { provider: { rucom: '1010101949482',
          #                                      identification_type: 'rut',
          #                                      name: 'Esteban Ceron',
          #                                      email: 'restebance@trazoro.com',
          #                                      identification_number: '129292294030302',
          #                                      phone: '10303039503',
          #                                      address: 'Carrera 9N #67N - 156'
          #                                },
          #                gold_batch: {
          #                                   castellanos:{
          #                                                       quantity: 20,
          #                                                       unit_value: 2500000
          #                                                      },
          #                                   tamines: {
          #                                                       quantity: 200,
          #                                                       unit_value: 2000000
          #                                                   },
          #                                   reales: {
          #                                               quantity: 5000,
          #                                               unit_value: 2000000
          #                                               },
          #                                   granos: {
          #                                                 quantity: 600000,
          #                                                 unit_value: 404003030303
          #                                                 },
          #                                  },
          #                 purchase:{
          #                                  price: 20202020202,
          #                                  law: 1000,
          #                                  grams: 1000000,
          #                                  code: '11jddj29292929292'
          #                                }
          #     }


          #values = params[:purchase]
          # date = Date.today
          # pdf = ::PdfFile.new(values , date , 'purchase_report')
          # #puts pdf.render
          # header['Content-Disposition'] = "attachment; filename=certificado_de_compra_#{date.month}_#{date.day}.pdf"
          # env['api.format'] = :pdf
          # body pdf.render
          render json: {test: 'teste'}
        end

      end

    end
  end
end