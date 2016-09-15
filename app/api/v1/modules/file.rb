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
          #puts pdf.render
          header['Content-Disposition'] = "attachment; filename= certificate_explotadores_mineros_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render
        end

        post 'download_p_b_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]

          date = Date.today
          pdf = ::OriginCertificates::PdfFile.new(values , date , 'p_b_certificate')
          header['Content-Disposition'] = "attachment; filename=certificado_plantas_beneficio_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end

        post 'download_c_c_report'  , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
          date = Date.today
          pdf = ::OriginCertificates::PdfFile.new(values , date , 'c_c_certificate')
          header['Content-Disposition'] = "attachment; filename=certificate_casas_compraventa_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end


        post 'download_b_c_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do

          date = Date.today  #fecha
          values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
          pdf = ::OriginCertificates::PdfFile.new(values , date , 'b_c_certificate')
          header['Content-Disposition'] = "attachment; filename=certificado_barequeros_chatarreros_#{date.month}_#{date.day}.pdf"
          env['api.format'] = :pdf
          body pdf.render

        end

        post 'download_purchase_report' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
           values = (JSON.parse env["api.request.body"]).deep_symbolize_keys!
           date = Time.now
           puts values.as_json
           pdf = ::OriginCertificates::PdfFile.new(values , date , 'purchase_report') #// corregir prueba para sales
           puts ' creating purchase report ... '
           header['Content-Disposition'] = "attachment; filename=certificado_de_compra_#{date.month}_#{date.day}.pdf"
           env['api.format'] = :pdf
           body pdf.render
          #render json: {test: 'teste'}
        end
      end
    end
  end
end
