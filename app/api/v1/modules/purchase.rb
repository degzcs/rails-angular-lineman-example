require 'cancancan'

module V1
  module Modules
    # Purchase EndPoint
    class Purchase < Grape::API
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

      #
      # POST
      #

      resource :purchases do
        desc 'Creates a purchase for the current user',
          notes: <<-NOTE
            ### Description
            Create a new purchase made for the current user. \n
            It returns the purchase values created. \n

            ### Example successful response

                {
                  "id"=>1,
                   "user_id"=>1,
                   "provider_id"=>1,
                   "gold_batch_id" => 1,
                   "price" => 1.5,
                   "origin_certificate_file" => "image.png",
                   "origin_certificate_sequence"=>"123456789",
                   "barcode_html" => "table html code",
                   "code" => '123456789012',
                }
          NOTE

        params do
          requires :purchase, type: Hash
        end

        post '/', http_codes: [
          [200, 'Successful'],
          [400, 'Invalid parameter'],
          [401, 'Unauthorized'],
          [404, 'Entry not found']
        ] do
          authorize! :create, ::Order
          # update params
          date = Date.today.to_date
          new_params = V1::Helpers::PurchaseHelper.format_params(params)
          gold_purchase_service = ::Purchase::BuyGoldService.new
          service_response = gold_purchase_service.call(
            order_hash: new_params[:purchase],
            gold_batch_hash: new_params[:gold_batch],
            current_user: current_user,
            remote_address: request.env['REMOTE_ADDR'],
            date: date
          )
          if service_response[:success]
            present gold_purchase_service.purchase_order, with: V1::Entities::Purchase
          else
            error!({ error: 'unexpected error', detail: service_response[:errors] }, 409)
          end
        end

        #
        # GET
        #

        desc 'returns all existent purchases for the current user',
          entity: V1::Entities::Purchase,
          notes: <<-NOTES
            Returns all existent sessions paginated
          NOTES

        params do
          use :pagination
        end

        get '/', http_codes: [[200, 'Successful'], [401, 'Unauthorized']] do
          authorize! :read, ::Order
          content_type 'text/json'
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          if legal_representative == current_user
            purchases = legal_representative.purchases.by_state(['paid', 'approved']).paginate(page: page, per_page: per_page)
          else
            purchases = Order.purchases_for(legal_representative, current_user).by_state(['paid', 'approved']).paginate(page: page, per_page: per_page)
          end
          header 'total_pages', purchases.total_pages.to_s
          present purchases, with: V1::Entities::Purchase
        end

        #
        # GET by State field
        #
        #
        # GET
        #

        desc 'returns all Free purchases to Sale for the current user',
          entity: V1::Entities::Purchase,
          notes: <<-NOTES
            Returns all Free purchases to Sale sessions paginated
          NOTES

        params do
          use :pagination
        end

        get '/free_to_sale', http_codes: [[200, 'Successful'], [401, 'Unauthorized']] do
          authorize! :read, ::Order
          content_type 'text/json'
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          if legal_representative == current_user
            purchases =
              Order.free_purchases(legal_representative).paginate(page: page, per_page: per_page)
            header 'total_pages', purchases.total_pages.to_s
          else
            purchases = []
          end
          present purchases, with: V1::Entities::Purchase
        end

        #
        # GET by state
        #

        desc 'returns all existent purchases by state for the current user', {
          entity: V1::Entities::Purchase,
          notes: <<-NOTES
            Returns all existent purchases by state paginated
          NOTES
        }

        params do
          use :pagination
          requires :state, type: String, desc: 'State string to transactions type sale example: dispatched, canceled, approved'
        end

        get '/by_state/:state', http_codes: [
          [200, 'Successful'],
          [401, 'Unauthorized'],
          [404, 'Entry not found']
        ] do
          authorize! :read, ::Order
          content_type 'text/json'
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          state = params[:state]
          # legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          purchases = ::Order.from_traders.by_state(state).as_buyer(current_user).paginate(:page => page, :per_page => per_page)
          header 'total_pages', purchases.total_pages.to_s
          present purchases, with: V1::Entities::Purchase
        end

        #
        # GET by id
        #

        desc 'returns one existent provider by :id',
          entity: V1::Entities::Purchase,
          notes: <<-NOTES
            Returns one existent purchase by :id
          NOTES

        params do
          requires :id, type: Integer, desc: 'Purchase ID'
        end

        get '/:id', http_codes: [[200, 'Successful'], [401, 'Unauthorized']] do
          authorize! :read, ::Order
          content_type 'text/json'
          purchase = ::Order.where(id: params[:id], type: 'purchase').last
          authorize! :read, purchase
          present purchase, with: V1::Entities::Purchase
        end
      end
    end
  end
end
