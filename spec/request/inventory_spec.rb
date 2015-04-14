require "spec_helper"

RSpec.describe "Inventory:", :type => :request do
  
  before :context do
    @user = create(:user)
    @token = @user.create_token
    gold_batch = create(:gold_batch)
    create_list(:purchase, 10, user_id: @user.id, gold_batch_id: gold_batch.id)
  end

  context "View inventory," do
    it "responds with a list of the current user purchases with available credits in every purchase inventory" do
      get '/api/v1/purchases', { per_page: 20 } , { "Authorization" => "Barer #{@token}" }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).count).to be 10
    end
  end


end