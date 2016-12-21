module V1
  module Modules
    class Reports < Grape::API

      before_validation do
        authenticate!
      end

      content_type :json , 'application/json'
      format :json
      resource :reports do
        #
        # GET royalties
        #
        desc 'returns a document with the selected format',
          notes: <<-NOTES
            Returns a document with the selected format
          NOTES

        params do
          # use params
        end
        post 'royalties' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          # values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
          time = Time.now
          royalty_service = ::Reports::Royalty::DocumentGeneration.new
          royalty_service.call(
            date: time.strftime("%Y-%m-%d"),
            signature_picture: params[:signature_picture],
            current_user: current_user,
            period: params[:period],
            selected_year: params[:selected_year],
            mineral_presentation: I18n.t(params[:mineral_presentation]),
            base_liquidation_price: params[:base_liquidation_price],
            royalty_percentage: params[:royalty_percentage]
          )
          if royalty_service.response[:success]
            # header['Content-Disposition'] = "attachment; filename=royalties_#{time}.pdf"
            # env['api.format'] = :pdf
            # body royalty_service.pdf
            present royalty_service.pdf_url(time.to_i)
          else
           error!({ error: 'unexpected error', detail: royalty_service.response[:errors] }, 409)
          end
        end

        params do
          requires :id, type: Integer, desc: 'Transaction ID', documentation: { example: 'sale_id, purchase_id' }
        end
        get '/:id/transaction_movements' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          # values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
          content_type 'text/json'
          order = ::Order.find(params[:id])

          time = Time.now
          taxes_service = ::Reports::Taxes::DocumentGeneration.new
          taxes_service.call(
            date: time.strftime("%Y-%m-%d"),
            current_user: current_user,
            order: order
          )
          if taxes_service.response[:success]
             #content_type 'text/csv'
             #env['api.format'] = :text
             
             # content_type "application/octet-stream"
             # header['Content-Disposition'] = "attachment; filename=taxes_#{time}.pdf"
             # env['api.format'] = :binary
             # taxes_service.csv.read_base_file
             present taxes_service.csv, with: V1::Entities::Report
               # :type => 'text/csv; charset=iso-8859-1; header=present',
               # :disposition => "attachment; filename=taxes_#{time}.csv"
            #present tax_service.pdf_url(time.to_i)
          else
           error!({ error: 'unexpected error', detail: taxes_service.response[:errors] }, 409)
          end
        end
      end
    end
  end
end