module V1
  module Modules
    class Reports < Grape::API

      before_validation do
        authenticate!
      end

      content_type :pdf , 'application/pdf'
      format :pdf
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
        get 'royalties' , http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          # values = (JSON.parse env["api.request.body"]).deep_symbolize_keys![:origin_certificate]
          time = Time.now
          royalty_service = ::Reports::Royalty::DocumentGeneration.new
          royalty_service.call(
            date: time.strftime("%Y-%m-%d"),
            signature_picture: params[:signature_picture],
            current_user: current_user,
            period: params[:period],
            selected_year: params[:selected_year],
            mineral_presentation: params[:mineral_presentation],
            base_liquidation_price: params[:base_liquidation_price],
            royalty_percentage: params[:royalty_percentage]
          )
          header['Content-Disposition'] = "attachment; filename=royalties_#{time}.pdf"
          env['api.format'] = :pdf
          body royalty_service.pdf
        end
      end
    end
  end
end