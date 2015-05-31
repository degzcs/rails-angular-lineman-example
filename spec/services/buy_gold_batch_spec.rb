require 'spec_helper'

describe BuyGoldBatch do

  let(:user){create(:user, available_credits: 100)}

  subject(:buy_gold_batch){ BuyGoldBatch.new(@purchase_hash, @gold_batch_hash, user)}

  context 'non trazoro user (from externanl user) ' do

    before :each do
      provider = create(:external_user)
      file_path = "#{Rails.root}/spec/support/test_images/image.png"
      seller_picture_path = "#{Rails.root}/spec/support/test_images/seller_picture.png"
      file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")
      seller_picture =  Rack::Test::UploadedFile.new(seller_picture_path, "image/jpeg")
      @gold_batch_hash ={
       "id" => 1,
      # "parent_batches" => "",
      "fine_grams" => 1.5,
      "grade" => 1,
      "inventory_id" => 1,
      }
      @purchase_hash ={
             "id"=>1,
           "user_id"=>1,
           "provider_id"=>provider.id,
           "gold_batch_id" => @gold_batch_hash["id"],
           "price" => 1.5,
           "origin_certificate_file" => file,
            "seller_picture" => seller_picture,
           "origin_certificate_sequence"=>"123456789",
           "trazoro" => false
      }
    end
    it 'should make a purchase and discount credits from de current user (buyer) available credits' do
      expected_credits = 100 - @gold_batch_hash['fine_grams'] # <-- this is a fine grams
      buy_gold_batch.from_non_trazoro_user!
      expect(buy_gold_batch.purchase.persisted?).to be true
      expect(user.reload.available_credits).to eq expected_credits
      # binding.pry
    end
  end
end