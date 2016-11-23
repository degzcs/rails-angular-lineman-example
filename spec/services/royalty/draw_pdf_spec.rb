require 'spec_helper'

describe Royalty::DrawPdf do
  let(:seller) do
    trader1 = create(
      :user, :with_profile, :with_company, :with_trader_role,
      name: 'Seller Company S.A.S',
      first_name: 'seller first_name',
      last_name: 'seller last_name',
      nit_number: '900123456789',
      document_number: '1010101010',
      city: City.find_by(name: 'MEDELLIN')
    )
    trader1.company.legal_representative
  end

  let(:buyer) do
    trader2 = create(
      :user, :with_profile, :with_company, :with_trader_role,
      name: 'Aquiles S.A',
      nit_number: '0987654321',
      first_name: 'buyer first_name',
      last_name: 'buyer last_name',
      document_number: '2020202020',
      city: City.find_by(name: 'MEDELLIN')
    )
    trader2.company.legal_representative
  end

  let(:gold_batches) do
    3.times.map { |index|  create(:gold_batch, fine_grams: index + 1) } # NOTE: gold batches with 1, 2 and 3 fine grams
  end

  let(:accepted_sale_orders) do
    gold_batches.map do |gold_batch|
      create :sale, seller: seller, buyer: buyer, gold_batch: gold_batch
    end
  end

  subject(:service) { Royalty::DrawPdf.new }

  context 'Draw the royalty document for current user (it should be legal_representative)' do
    it 'should check the consistency of the document' do
      signature_picture_path = "#{Rails.root}/spec/support/images/signature.jpg"
      signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
      # expected_hash = '2ebeaa2e22115cb5a6d84aad646f808e3aafe20f389ee73515becca13198d1d7'
      response = service.call(
        current_user: seller,
        orders: accepted_sale_orders,
        mineral_presentation: 'Amalgama',
        royalty_period: 4,
        royalty_year: Time.now.strftime("%y"), # ex. 16
        date: Time.now,
        signature_picture: signature_picture
      )
      system "mkdir -p #{ Rails.root }/tmp/royalty"
      saved_file = service.file.render_file("#{ Rails.root }/tmp/royalty/royalty_test.pdf")
      file_payload = File.read(saved_file)
      file_hash = Digest::SHA256.hexdigest file_payload
      expect(response[:errors]).to eq []
      expect(response[:success]).to be true
      # expect(file_hash).to eq expected_hash
    end
  end
end
