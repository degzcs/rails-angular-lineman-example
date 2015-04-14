require "spec_helper"

RSpec.describe "Inventory:", :type => :request do
  
  before :context do
    @user = create(:user)
    @token = @user.create_token
  end

  context "View inventory," do
    before(:all) do
      @user2 = create(:user)
      gold_batch = create(:gold_batch)
      @number_of_purchases_user_1 = 10
      @number_of_purchases_user_2 = 5
      create_list(:purchase, @number_of_purchases_user_1, user_id: @user.id, gold_batch_id: gold_batch.id)
      create_list(:purchase, @number_of_purchases_user_2, user_id: @user2.id, gold_batch_id: gold_batch.id)
    end
    it "responds with a paginated list of the current user purchases" do
      get '/api/v1/purchases', { per_page: 40 } , { "Authorization" => "Barer #{@token}" }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).count).to be @number_of_purchases_user_1
    end
  end


end