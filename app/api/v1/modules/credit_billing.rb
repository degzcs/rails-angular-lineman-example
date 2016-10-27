module V1
  module Modules
    class CreditBilling <  Grape::API

      before_validation do
        authenticate!
      end

      format :json
      content_type :json, 'application/json'

      helpers do

        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end

        params :id do
          requires :id, type: Integer, desc: 'Credit Billing ID'
        end

        params :credit_billing do
          requires :credit_billing, type: Hash do
            requires  :user_id, type: Integer, desc: 'unit', documentation: { example: '...' }
            requires  :quantity, type: String, desc: 'unit', documentation: { example: '...' }
          end
        end

      end

      #
      # GET /
      #

      resource :credit_billings do
        desc 'returns all existent credit billings', {
          entity: V1::Entities::CreditBilling,
          notes: <<-NOTES
            Returns all existent credit billings paginated
          NOTES
        }
        params do
          use :pagination
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          credit_billings = ::CreditBilling.paginate(:page => page, :per_page => per_page)
          header 'total_pages', credit_billings.total_pages.to_s
          present credit_billings, with: V1::Entities::CreditBilling
        end

        #
        # GET /:id
        #

        desc 'returns one existent credit_billing by :id', {
          entity: V1::Entities::CreditBilling,
          notes: <<-NOTES
            Returns one existent Credit billing by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          provider = ::CreditBilling.find(params[:id])
          present provider, with: V1::Entities::CreditBilling
        end

        #
        # POST /
        #

        desc 'creates a new credit billing', {
            entity: V1::Entities::CreditBilling,
            notes: <<-NOTE
              ### Description
              It creates a new credit billing record and returns its current representation.
            NOTE
          }
        params do
          use :credit_billing
        end
        post '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          credit_billing = ::CreditBilling.new(params[:credit_billing])

          if credit_billing.save
            present credit_billing, with: V1::Entities::CreditBilling
          else
            error!(credit_billing.errors.inspect, 400)
            Rails.logger.info(credit_billing.errors.inspect)
          end
        end
      end
    end
  end
end