require 'spec_helper'

describe Purchase::BuyGoldService do

  let(:company){ create :company}
  let(:legal_representative) do
    user = company.legal_representative
    user.update_column :available_credits, 100
    user
  end

  subject(:service){ Purchase::BuyGoldService.new }

  context 'non trazoro user (from externanl user) ' do

    before :each do
      seller = create(:external_user, :with_company)
      file_path = "#{ Rails.root }/spec/support/pdfs/origin_certificate_file.pdf"
      file = Rack::Test::UploadedFile.new(file_path, "application/pdf")

      seller_picture_path = "#{ Rails.root }/spec/support/images/seller_picture.png"
      seller_picture =  Rack::Test::UploadedFile.new(seller_picture_path, "image/jpeg")
      @gold_batch_hash ={
       # "id" => 1,
      # "parent_batches" => "",
      "fine_grams" => 1.5,
      "grade" => 999,
      # "inventory_id" => 1,
      "extra_info" => { 'grams' => 1.5 }
      }
      @purchase_hash ={
           # "id"=>1,
           # "user_id"=>1,
           "seller_id" => seller.id,
           # "gold_batch_id" => @gold_batch_hash["id"],
           "price" => 1.5,
           "origin_certificate_file" => file,
           "seller_picture" => seller_picture,
           "origin_certificate_sequence"=>"123456789",
           "trazoro" => false
      }
    end

    it 'should to make a purchase and discount credits from de company' do
      expected_credits = 100 - @gold_batch_hash['fine_grams'] # <-- this is a fine grams
      response = service.call(
        purchase_hash: @purchase_hash,
        gold_batch_hash: @gold_batch_hash,
        current_user: legal_representative, # TODO: worker
        )
      expect(response[:success]).to be true
      expect(service.purchase.persisted?).to be true
      expect(company.reload.available_credits).to eq expected_credits
      # binding.pry
    end

    it 'should to make a purchase and discount credits to the current user' do
    end
  end

  context 'errors' do
    before :each do
      @gold_batch_hash ={ fine_grams: 'invalid' }
      @purchase_hash ={ price: 'invalid' }
    end

    it 'raise errors' do
      expect do
        service.call(
        purchase_hash: @purchase_hash,
        gold_batch_hash: @gold_batch_hash,
        buyer: user
        )
      end.to raise_error
    end
  end
end