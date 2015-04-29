module V1
  module Modules
    class Inventory <  Grape::API

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

      resource :inventories do

        desc 'Updates an inventory', {
            notes: <<-NOTE
              ### Description
              Updates an inventory with new data for a given sale \n
              
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
         requires :id, type: Integer
         requires :sale_id, type: Integer
         requires :amount_picked, type: Float
        end
        put '/:id', http_codes: [
            [200, "Successful"],
            [400, "Invalid parameter"],
            [401, "Unauthorized"],
            [404, "Entry not found"],
          ] do
            inventory = ::Inventory.find(params[:id])
            amount_picked = params[:amount_picked]
            inventory.update_remainig_amount(amount_picked)
            # 
            #Sold batch registration
            #
            sale = ::Sale.find(params[:sale_id])
            sold_batch = ::SoldBatchRegistration.register_sold_batch(sale,inventory.purchase,amount_picked)
        end
      end
    end
  end
end