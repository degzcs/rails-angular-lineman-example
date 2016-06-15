# == Schema Information
#
# Table name: sales
#
#  id            :integer          not null, primary key
#  courier_id    :integer
#  client_id     :integer
#  user_id       :integer
#  gold_batch_id :integer
#  grams         :float
#  created_at    :datetime
#  updated_at    :datetime
#

module V1
  module Modules
    class Sale <  Grape::API

      before_validation do
        authenticate!
      end

       helpers do
        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
      end


      format :json
      content_type :json, 'application/json'

        # params :auth do
        #   requires :access_token, type: String, desc: 'Auth token', documentation: { example: '837f6b854fc7802c2800302e' }
        # end

      resource :sales do

        #
        # POST
        #

        desc 'Creates a sale for the current user', {
            notes: <<-NOTE
              ### Description
              Create a new sale made for the current user. \n
              It returns the sale values created. \n

              ### Example successful response

                  {
                    "id"=>1,
                     "courier_id"=>1,
                     "client_id"=>1,
                     "user_id" => 1,
                     "gold_batch_id" => 1,
                     "grams" => "2323",
                  }
            NOTE
          }

        params do
           requires :sale, type: Hash
           requires :gold_batch, type: Hash
           optional :selected_purchase_ids, type: Array
        end

        post '/', http_codes: [
            [200, "Successful"],
            [400, "Invalid parameter"],
            [401, "Unauthorized"],
            [404, "Entry not found"],
          ] do
            registration_service = ::Sale::RegistrationService.new
            response = registration_service.call(
              sale_hash: params[:sale],
              current_user: current_user,
              gold_batch_hash: params[:gold_batch],
              selected_purchase_ids: params[:selected_purchase_ids],
              )

            present registration_service.sale, with: V1::Entities::Sale
            Rails.logger.info(response)
        end

        #
        # GET
        #

        desc 'returns all existent sale for the current user', {
          entity: V1::Entities::Sale,
          notes: <<-NOTES
            Returns all existent sales paginated
          NOTES
        }

        params do
          use :pagination
        end

        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          sales = legal_representative.sales.paginate(:page => page, :per_page => per_page)
          header 'total_pages', sales.total_pages.to_s
          present sales, with: V1::Entities::Sale
        end

        #
        # GET by code
        #

        desc 'Given sale code, it returns both provider and gold batch information necessary for made a purchase', {
          entity: V1::Entities::SaleForPurchase,
          notes: <<-NOTES
            Given sale code, it returns both provider and gold batch information necessary for made a purchase
          NOTES
        }

        params do
          requires :code, type: String, desc: 'Sale ID'
        end

        get 'get_by_code/:code', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          sale = legal_representative.sales.find_by(code: params[:code])
          present sale, with: V1::Entities::SaleForPurchase
        end

        #
        # GET by id
        #

        desc 'returns one existent sale by :id', {
          entity: V1::Entities::Sale,
          notes: <<-NOTES
            Returns one existent sale by :id
          NOTES
        }

        params do
          requires :id, type: Integer, desc: 'Sale ID'
        end

        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          sale = legal_representative.sales.find(params[:id])
          present sale, with: V1::Entities::Sale
        end

        #
        # GET batches
        #

        desc 'returns all batches for a given sale', {
          entity: V1::Entities::Sale,
          notes: <<-NOTES
            Returns all existent sales paginated
          NOTES
        }

        params do
          requires :id, type: Integer, desc: 'Sale ID'
        end

        get '/:id/batches', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          batches = legal_representative.sales.find(params[:id]).batches
          present batches, with: V1::Entities::SoldBatch
        end
      end
    end
  end
end