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
require 'cancancan'

module V1
  module Modules
    class Sale < Grape::API
      before_validation do
        authenticate!
      end

      helpers do
        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end

        params :transition do
          requires :id, type: Integer, desc: 'Sale Id'
          requires :transition, type: String, desc: 'Transition string to trigger and set the transaction state field example: send_info!, agree!, cancel!, crash!'
        end
      end

      rescue_from ::CanCan::AccessDenied do
        error!('403 Forbidden', 403)
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

        desc 'Creates a sale for the current user',{
          notes: <<-NOTE
              ### Description
              Create a new sale made for the current user. \n
              It returns the sale values created. \n

              ### Example successful response

                  {
                    'id'=>1,
                     'courier_id'=>1,
                     'buyer_id'=>1,
                     'user_id' => 1,
                     'gold_batch_id' => 1,
                     'grams' => '2323',
                  }
            NOTE
        }

        params do
          requires :sale, type: Hash
          requires :gold_batch, type: Hash
          requires :selected_purchases, type: Array
        end

        post '/', http_codes: [
            [200, 'Successful'],
            [400, 'Invalid parameter'],
            [401, 'Unauthorized'],
            [404, 'Entry not found'],
            ] do
            authorize! :create, ::Order
            selected_purchase_ids = params[:selected_purchases].map { |purchase| purchase[:id] }
            registration_service = ::Sale::SaleGoldService.new
            response = registration_service.call(
              order_hash: params[:sale],
              current_user: current_user,
              gold_batch_hash: params[:gold_batch],
              selected_purchase_ids: selected_purchase_ids,
              remote_address: request.env['REMOTE_ADDR'],
              )
            if response[:success]
              present registration_service.sale_order, with: V1::Entities::Sale
              Rails.logger.info(response)
            else
              error!({error: 'unexpected error', detail: response[:errors] }, 409)
            end
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

        get '/', http_codes: [
          [200, 'Successful'],
          [401, 'Unauthorized']
          ] do
          authorize! :read, ::Order
          content_type 'text/json'
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          if legal_representative == current_user
            sales = legal_representative.sales.by_state(['paid', 'approved']).paginate(page: page, per_page: per_page)
            header 'total_pages', sales.total_pages.to_s
          else
            sales = []
          end
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

        get 'get_by_code/:code', http_codes: [ [200, 'Successful'], [401, 'Unauthorized'] ] do
          authorize! :read, ::Order
          content_type 'text/json'
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

        get '/:id', http_codes: [ [200, 'Successful'], [401, 'Unauthorized'] ] do
          authorize! :read, ::Order
          content_type 'text/json'
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          sale = legal_representative.sales.where(id: params[:id], type: 'sale').last
          authorize! :read, sale
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

        get '/:id/batches', http_codes: [ [200, 'Successful'], [401, 'Unauthorized'] ] do
          content_type 'text/json'
          legal_representative = V1::Helpers::UserHelper.legal_representative_from(current_user)
          batches = legal_representative.sales.where(id: params[:id], type: 'sale').last.batches
          present batches, with: V1::Entities::SoldBatch
        end

        #
        # GET by state as seller
        #

        desc 'returns all existent sales by state for the current user(seller)', {
          entity: V1::Entities::Sale,
          notes: <<-NOTES
            Returns all existent sales by state paginated
          NOTES
        }

        params  do
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
          sales = ::Order.from_traders.by_state(state).as_seller(current_user).paginate(:page => page, :per_page => per_page)
          header 'total_pages', sales.total_pages.to_s
          present sales, with: V1::Entities::Sale
        end

        #
        # GET by transition
        #

        desc 'Trigger a transition for transaction state field', {
          entity: V1::Entities::Sale,
          notes: <<-NOTES
            Returns the sale with its transaction state field update by the transition
          NOTES
        }
        # TODO: it should be a PUT action
        get '/:id/transition', http_codes: [
            [200, 'Successful'],
            [400, 'Invalid parameter'],
            [401, 'Unauthorized'],
            [404, 'Entry not found']
          ] do
          authorize! :read, ::Order
          content_type 'text/json'
          # page = params[:page] || 1
          # per_page = params[:per_page] || 10
          @sale = ::Order.find(params[:id])
          transition = params[:transition].to_sym
          @sale.__send__(transition, current_user, request.env['REMOTE_ADDR'])
          # @sale.save!
          # header 'total_pages', @sale.total_pages.to_s
          present @sale, with: V1::Entities::Sale
        end

        desc 'Creates a sale for the current user in state published', {
          entity: V1::Entities::Sale,
          notes: <<-NOTE
            Create a sale by the current user to be published in the marketplace
          NOTE
        }

        params do
          requires :sale, type: Hash
          requires :gold_batch, type: Hash
          requires :selected_purchases, type: Array
        end

        post '/marketplace', http_codes: [
          [200, 'Successful'],
          [400, 'Invalid parameter'],
          [401, 'Unauthorized'],
          [404, 'Entry not found'],
          ] do
          authorize! :create, ::Order
          selected_purchase_ids = params[:selected_purchases].map { |purchase| purchase[:id] }
          marketplace_service = ::Marketplace::SaleService.new
          response = marketplace_service.call(
            order_hash: params[:sale],
            current_user: current_user,
            gold_batch_hash: params[:gold_batch],
            selected_purchase_ids: selected_purchase_ids,
            remote_address: request.env['REMOTE_ADDR'],
          )
          if response[:success]
            present marketplace_service.sale_order, with: V1::Entities::Sale
            Rails.logger.info(response)
          else
            error!({error: 'unexpected error', detail: response[:errors] }, 409)
          end
        end

        desc 'Create a purchase request with the passed order(sale)', {
          entity: V1::Entities::Sale,
          notes: <<-NOTE
            Create a purchase request with the passed order(sale)
          NOTE
        }

        params do
          requires :sale_id, type: Integer
        end

        put '/buy_request', http_codes: [
          [200, 'Successful'],
          [400, 'Invalid parameter'],
          [401, 'Unauthorized'],
          [404, 'Entry not found'],
          ] do
          sale = Order.find(params[:sale_id])
          purchase_request = sale.purchase_requests.new(buyer_id: current_user.id)
          begin
            purchase_request.save!
            present purchase_request.order, with: V1::Entities::Sale
          rescue Exception => e
            if e.class == ActiveRecord::RecordNotUnique
              error!({error: 'unexpected error', details: 'Usted ya hizo una peticion por este lote' }, 409)
            else
              error!({error: 'unexpected error', details: e.message }, 409)
            end
          end
        end
      end
    end
  end
end
