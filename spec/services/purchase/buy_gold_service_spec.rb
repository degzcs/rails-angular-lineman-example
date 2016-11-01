require 'spec_helper'

describe Purchase::BuyGoldService do
  let(:company) { create :company }
  let(:legal_representative) do
    user = company.legal_representative
    user.profile.update_column :available_credits, @initial_credits
    user
  end

  subject(:service) { Purchase::BuyGoldService.new }

  context 'non trazoro user (from externanl user)' do
    before :each do
      settings = Settings.instance
      settings.data = { monthly_threshold: 30, fine_gram_value: 1000, vat_percentage: 16 }
      settings.save!
      @initial_credits = 100
      @seller = create(:user, :with_profile, :with_personal_rucom, provider_type: 'Barequero')

      file_path = "#{Rails.root}/spec/support/pdfs/origin_certificate_file.pdf"
      Rack::Test::UploadedFile.new(file_path, 'application/pdf')

      seller_picture_path = "#{Rails.root}/spec/support/images/seller_picture.png"
      seller_picture = Rack::Test::UploadedFile.new(seller_picture_path, 'image/jpeg')

      signature_picture_path = "#{Rails.root}/spec/support/images/signature.jpg"
      @signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')

      @gold_batch_hash = {
        'fine_grams' => 1.5,
        'grade' => 999,
        'extra_info' => { 'grams' => 1.5 }
      }
      @order_hash = {
        'seller_id' => @seller.id,
        'price' => 1.5,
        'seller_picture' => seller_picture,
        'trazoro' => false,
        'signature_picture' => @signature_picture
      }
    end

    it 'should to make a purchase order and discount credits from company' do
      expected_credits = @initial_credits - @gold_batch_hash['fine_grams'] # <-- this is a fine grams
      response = service.call(
        order_hash: @order_hash,
        gold_batch_hash: @gold_batch_hash,
        current_user: legal_representative, # TODO: worker
        date: '2016/07/15'.to_date
      )
      expect(response[:success]).to be true
      expect(service.purchase_order.persisted?).to be true
      expect(company.reload.available_credits).to eq expected_credits
    end

    context 'show validation message' do
      it 'should to notify that user does not have enough available credits' do
        @initial_credits = 0

        response = service.call(
          order_hash: @order_hash,
          gold_batch_hash: @gold_batch_hash,
          current_user: legal_representative, # TODO: worker
          date: '2016/07/15'.to_date
        )
        expect(response[:success]).to be false
        expect(response[:errors]).to include 'No tienes los suficientes creditos para hacer esta compra'
        expect(service.purchase_order).to be nil
      end

      it 'should throw a message telling to barequero reach the limit for this month' do
        gold_batch = create :gold_batch, fine_grams: 30
        create :purchase, seller: @seller, gold_batch: gold_batch
        seller_name = UserPresenter.new(@seller, self).name
        # Try to buy gold
        response = service.call(
          order_hash: @order_hash,
          gold_batch_hash: @gold_batch_hash,
          current_user: legal_representative, # TODO: worker
          date: Date.today.to_date
        )

        msg = 'Usted no puede realizar esta compra, debido a que con esta compra el'
        msg += ' barequero exederia el limite permitido por mes. El total comprado hasta el momento'
        msg += " por #{seller_name} es: 30.0 gramos finos"

        expect(response[:errors]).to include msg
        expect(response[:success]).to be false
        expect(service.purchase_order).to be nil
      end
    end
  end

  context 'cofiguration service errors' do
    before :each do
      @gold_batch_hash = { fine_grams: 'invalid' }
      @order_hash = { price: 'invalid' }
    end

    it 'raise a date param error' do
      expect do
        service.call(
          current_user: legal_representative,
          order_hash: @order_hash,
          gold_batch_hash: @gold_batch_hash
        )
      end.to raise_error('You must to provide a date option')
    end

    it 'raise a date order_hash error' do
      expect do
        service.call(
          current_user: legal_representative,
          gold_batch_hash: @gold_batch_hash,
          date: Date.today
        )
      end.to raise_error('You must to provide a order_hash option')
    end

    it 'raise a date gold_batch_hash error' do
      expect do
        service.call(
          current_user: legal_representative,
          order_hash: @order_hash,
          date: Date.today
        )
      end.to raise_error('You must to provide a gold_batch_hash option')
    end

    it 'raise a current_user param error' do
      expect do
        service.call(
          order_hash: @order_hash,
          gold_batch_hash: @gold_batch_hash,
          date: Date.today
        )
      end.to raise_error('You must to provide a current_user option')
    end
  end
end
