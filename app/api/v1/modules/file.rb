module V1
  module Modules
    class File <  Grape::API

     # before_validation do
     #  authenticate!
     # end

      content_type :pdf , 'application/pdf'
      format :pdf

      resource :files do

        post 'download_e_m_certificate' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
        date = Date.today
        values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
        pdf = ::PdfFile.new(values , date , 'e_m_certificate')
        header['Content-Disposition'] = "attachment; filename= certificate_explotadores_mineros_#{date.month}_#{date.day}.pdf"
        env['api.format'] = :pdf
        body pdf.render

        end

        post 'download_p_b_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]

          date = Date.today
          pdf = ::PdfFile.new(values , date , 'p_b_certificate')
          header['Content-Disposition'] = "attachment; filename=certificado_plantas_beneficio_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end

        post 'download_c_c_report'  , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
          date = Date.today
          pdf = ::PdfFile.new(values , date , 'c_c_certificate')
          header['Content-Disposition'] = "attachment; filename=certificate_casas_compraventa_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end


        post 'download_b_c_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          date = Date.today  #fecha
          values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
          pdf = ::PdfFile.new(values , date , 'b_c_certificate')
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

           # values = { provider: {               type: 'Sociedad anonima',
           #                                      nit: '19191914jfjfjfjf',
           #                                      name: 'Esteban Ceron',
           #                                      identification_number: '129292294030302',
           #                                      rucom: '1010101949482',
           #                                      address: 'Carrera 9N #67N - 156',
           #                                      phone: '10303039503'
           #                                },
           #            buyer:{
           #                                      type: 'Sociedad anonima',
           #                                      nit: '19191914jfjfjfjf',
           #                                      rucom: '1010101949482',
           #                                      name: 'Esteban Ceron',
           #                                      office: 'sede principal',
           #                                      identification_number: '129292294030302',

           #                                      address: 'Carrera 9N #67N - 156',
           #                                      phone: '10303039503'
           #            },

           #            gold_batch: {
          #                                   grade: 999,
           #                                   castellanos:{
           #                                                       quantity: 200,
           #                                                       grams: 2500000
           #                                                      },
           #                                   tomines: {
           #                                                       quantity: 200,
           #                                                       grams: 2000000
           #                                                   },
           #                                   riales: {
           #                                               quantity: 5000,
           #                                               grams: 2000000
           #                                               },
           #                                   ozs: {
           #                                                 quantity: 600000,
           #                                                 grams: 404003030303
           #                                                 },
           #                                  },
           #            purchase:{
           #                                  price: 20202020202,
           #                                  price_per_gram: 2020220 ,
           #                                  grams: 1000000,
           #                                  fine_grams: 123546,
           #                                  code: '11jddj29292929292'
           #                                }
           #     }

           values = (JSON.parse env["api.request.body"]).deep_symbolize_keys!
           date = Time.now
           puts values.as_json 
           pdf = ::PdfFile.new(values , date , 'purchase_report') #// corregir prueba para sales
           puts ' creating purchase report ... '
           header['Content-Disposition'] = "attachment; filename=certificado_de_compra_#{date.month}_#{date.day}.pdf"
           env['api.format'] = :pdf
           body pdf.render
          #render json: {test: 'teste'}
        end

        # download_sales_report
        get 'download_sales_report/:sale_id' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          sale_id = params[:sale_id]
          sale = SalePDFService.new(sale_id)

          values = sale.values
          #binding.pry
          # purchase --> type
          #castellanos
          #tamines
          #reales
          #granos
          # hash
=begin
           values = { provider: {
                          social: 'razon social',
                          name: 'Esteban Ceron',
                          type: 'Sociedad anonima',
                          identification_number: '129292294030302',
                          nit: '19191914jfjfjfjf',
                          rucom: '1010101949482',
                          address: 'Carrera 9N #67N - 156',
                          email: 'email@trazoro.com',
                          phone: '10303039503'
                                },
                      buyer:    {
                          social: 'razon social',
                          name: 'Esteban Ceron',
                          type: 'Sociedad anonima',
                          identification_number: '129292294030302',
                          nit: '19191914jfjfjfjf',
                          rucom: '1010101949482',
                          address: 'Carrera 9N #67N - 156',
                          email: 'email@trazoro.com',
                          phone: '10303039503'
                                },
                      carrier: {
                          first_name: 'hola',
                          last_name: 'hola',
                          phone: '292929292',
                          address: 'address phone',
                          identification_number: '122322222323',
                          company: 'compania servientrega',
                          nit: '22020202002020'
                      },
                       purchase:{
                          price: 20202020202,
                          law: 20 ,
                          grams: 1000000,
                          fine_grams: 123546,
                          code: '770000120040'
                       },
                      batch:[{
                              id_purchase: '11010101001',
                              id_provider: '1112222323',
                              social: 'razon social',
                              certificate_number: '2222929292922',
                              rucom: '2234324242342',
                              fine_grams: 'gramos finos'
                              },
                             {
                                 id_purchase: '11011010101',
                                 id_provider: '1112221323',
                                 social: 'razon social',
                                 certificate_number: '2222929292922',
                                 rucom: '2234324242342',
                                 fine_grams: 'gramos finos'
                             },
                             {
                                 id_purchase: '11011010101',
                                 id_provider: '1112221323',
                                 social: 'razon social',
                                 certificate_number: '2222929292922',
                                 rucom: '2234324242342',
                                 fine_grams: 'gramos finos'
                             },
                             {
                                 id_purchase: '110101010101',
                                 id_provider: '11122221323',
                                 social: 'razon social',
                                 certificate_number: '2222929292922',
                                 rucom: '2234324242342',
                                 fine_grams: 'gramos finos'
                             },
                             ],
                        certificate_path:'uploads/sale/origin_certificate_file/3/certificate.pdf'

                      }

=end
          #     }

          #values = (JSON.parse env["api.request.body"]).deep_symbolize_keys!

          date = Time.now
          pdf = ::PdfFile.new(values , date , 'sales_report')
          puts ' creating sales report ... '
          header['Content-Disposition'] = "attachment; filename=certificado_de_compra_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render
        end


      end

    end
  end
end
