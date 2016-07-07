require 'spec_helper'

describe Purchase::BuyGoldService do

  let(:company){ create :company}
  let(:legal_representative) do
    user = company.legal_representative
    user.profile.update_column :available_credits, @initial_credits
    user
  end

  subject(:service){ Purchase::BuyGoldService.new }

  context 'non trazoro user (from externanl user) ' do

    before :each do
      @initial_credits = 100
      @seller = create(:external_user, :with_company)
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
           "seller_id" => @seller.id,
           # "gold_batch_id" => @gold_batch_hash["id"],
           "price" => 1.5,
           "origin_certificate_file" => file,
           "seller_picture" => seller_picture,
           "origin_certificate_sequence"=>"123456789",
           "trazoro" => false
      }
    end

    it 'should to make a purchase and discount credits from de company' do
      expected_credits = @initial_credits - @gold_batch_hash['fine_grams'] # <-- this is a fine grams
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


    context 'show validation message' do
      it 'should to notify that user does not have enough available credits' do
          @initial_credits = 0

          response = service.call(
          purchase_hash: @purchase_hash,
          gold_batch_hash: @gold_batch_hash,
          current_user: legal_representative, # TODO: worker
          )
        expect(response[:success]).to be false
        expect(response[:errors]).to include 'No tienes los suficientes creditos para hacer esta compra'
        expect(service.purchase).to be nil
      end

      it 'should throw a message telling to barequero reach the limin for this month' do
        gold_batch = create :gold_batch, fine_grams: 30
        purchase = create :purchase, seller: @seller, gold_batch: gold_batch
        seller_name = UserPresenter.new(@seller, self).name
        # Try to buy gold
        response = service.call(
          purchase_hash: @purchase_hash,
          gold_batch_hash: @gold_batch_hash,
          current_user: legal_representative, # TODO: worker
          )
        expect(response[:success]).to be false
        expect(response[:errors]).to include "Usted no puede realizar esta compra, debido a que con esta compra el barequero exederia el limite permitido por mes. El total comprado hasta el momento por #{ seller_name } es: 30.0 gramos finos"
        expect(service.purchase).to be nil
      end
    end
  end

  context 'cofiguration service errors' do
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