describe 'Reports', type: :request do
  describe :v1 do
    let(:seller) do
      create(:user, :with_company, :with_trader_role).company.legal_representative
    end

    let(:buyer) do
      create(:user, :with_company, :with_trader_role).company.legal_representative
    end
    context 'royalties' do
      before :each do
        gold_batches = 3.times.map { |i| create(:gold_batch, fine_grams: i+1) } # NOTE: gold baches with 1, 2, 3 fine grams
        payment_date = '02-02-2016'.to_date
        orders = gold_batches.each_with_index.map do |gold_batch, i|
        create(:order,
          seller: seller,
          buyer: buyer,
          transaction_state: 'completed',
          gold_batch: gold_batch,
          payment_date: payment_date + i,
          price: 10_000
          )
        end
        @token = seller.create_token
      end

      it 'should to create a royalty report in PDF format' do
        file_path = "#{Rails.root}/spec/support/images/signature_picture.png"
        signature_picture_file = Rack::Test::UploadedFile.new(file_path, 'image/jpeg')
        params = {
          'signature_picture' => signature_picture_file,
          'period' => 1,
          'selected_year' => '2016',
          'mineral_presentation' => 'Amalgama',
          'base_liquidation_price' => '88.12',
          'royalty_percentage' => '4'
        }

        post "/api/v1/reports/royalties", params, 'Authorization' => "Barer #{ @token }"
        expect(response.body).not_to be_empty # IMPROVE: verify the PDF file content.
      end
    end
  end
end