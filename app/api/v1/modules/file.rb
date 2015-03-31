module V1
  module Modules
    class File <  Grape::API

      content_type :pdf , 'application/pdf'
      format :pdf

      get 'download_file' do
        pdf = ::PdfFile.new('hola')
        puts pdf.render
        header['Content-Disposition'] = "attachment; filename=hola.pdf"
        env['api.format'] = :pdf
        body pdf.render
        #send_data pdf.render, filename: "paciente_cita medica.pdf", type: "application/pdf"
        #pdf.render
      end

    end
  end
end