require "spec_helper"

RSpec.describe "Inventory:", :type => :request do

  before :context do
    @buyer = create(:user, :with_company)
    @token = @buyer.create_token
  end

  context "View inventory," do
    before(:all) do
      @seller = create(:user, :with_company)
      @number_of_purchases_user_1 = 10
      @number_of_purchases_user_2 = 5
      create_list(:purchase, @number_of_purchases_user_1, :with_proof_of_purchase_file, seller_id: @buyer.id)
      create_list(:purchase, @number_of_purchases_user_2, :with_proof_of_purchase_file,  seller_id: @seller.id)
    end

    # TODO: This test no make sence here because this end point is already tested in
    # purchase_spec.rb
    xit "responds with a paginated list of the current user purchases" do
      get '/api/v1/purchases', { per_page: 40 } , { "Authorization" => "Barer #{@token}" }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).count).to be @number_of_purchases_user_1
    end
  end


end