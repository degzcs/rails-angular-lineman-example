module V1
  module Modules
    class Purchase <  Grape::API

      before_validation do
        authenticate!
      end

      format :json
      content_type :json, 'application/json'

        # params :auth do
        #   requires :access_token, type: String, desc: 'Auth token', documentation: { example: '837f6b854fc7802c2800302e' }
        # end

      resource :purchases do

        desc 'Update the current user', {
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
                     "amount" => 1.5,
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
              purchase = ::Purchase.new(params[:purchase].merge( user_id: current_user.id))
              purchase.save
              present purchase, with: V1::Entities::Purchase
        end
      end
    end
  end
end