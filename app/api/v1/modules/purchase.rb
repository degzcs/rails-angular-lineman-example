module V1
  module Modules
    class Purchase <  Grape::API

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

      resource :purchases do

        desc 'Creates a purchase for the current user', {
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
                  }
            NOTE
          }
        params do
           requires :purchase, type: Hash
        end
        post '/', http_codes: [
            [200, "Successful"],
            [400, "Invalid parameter"],
            [401, "Unauthorized"],
            [404, "Entry not found"],
          ] do

              # update params
              files =params[:purchase].slice(:files)[:files]
              origin_certificate_file = files.reject{|file| file['filename'] =~ /seller_picture/}.first
              seller_picture = files.select{|file| file['filename'] =~ /seller_picture/}.first
              params[:purchase].except!(:files).merge!(origin_certificate_file: origin_certificate_file, seller_picture: seller_picture)
              # binding.pry

              # create purchase
              purchase = current_user.purchases.build(params[:purchase])
              purchase.build_gold_batch(params[:gold_batch])
              purchase.save!
              present purchase, with: V1::Entities::Purchase
              Rails.logger.info(purchase.errors.inspect)
        end

        desc 'returns all existent purchases for the current user', {
          entity: V1::Entities::Purchase,
          notes: <<-NOTES
            Returns all existent sessions paginated
          NOTES
        }
        params do
          use :pagination
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          purchases = current_user.purchases.paginate(:page => page, :per_page => per_page)
          header 'total_pages', purchases.total_pages.to_s
          present purchases, with: V1::Entities::Purchase
        end
        desc 'returns one existent provider by :id', {
          entity: V1::Entities::Purchase,
          notes: <<-NOTES
            Returns one existent purchase by :id
          NOTES
        }
        params do
          requires :id, type: Integer, desc: 'Purchase ID'
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          purchase = ::Purchase.find(params[:id])
          present purchase, with: V1::Entities::Purchase
        end
      end
    end
  end
end