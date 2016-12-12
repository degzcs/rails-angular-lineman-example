require 'spec_helper'

describe Reports::Royalty::DrawPdf do
  let(:seller) do
    create(
      :user, :with_profile, :with_company, :with_trader_role,
      name: 'Seller Company S.A.S',
      first_name: 'seller first_name',
      last_name: 'seller last_name',
      nit_number: '900123456789',
      address: 'Street 123',
      document_number: '1010101010',
      phone_number: '3101010101',
      legal_representative: true,
      company_email: 'seller.email@test.com',
      city: City.find_by(name: 'MEDELLIN')
    )
  end

  let(:buyer) do
    create(
      :user, :with_profile, :with_company, :with_trader_role,
      name: 'Buyer Company S.A',
      nit_number: '0987654321',
      address: 'Street 456',
      first_name: 'buyer first_name',
      last_name: 'buyer last_name',
      document_number: '2020202020',
      phone_number: '3202020202',
      legal_representative: true,
      company_email: 'buyer.email@test.com',
      city: City.find_by(name: 'MEDELLIN')
    )
  end

  subject(:service) { Reports::Royalty::DrawPdf.new }

  context 'Draw the royalty document for current user (it should be legal_representative)' do
    it 'should check the consistency of the document' do
      signature_picture_path = "#{Rails.root}/spec/support/images/signature.jpg"
      signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
      expected_hash = '2e98b72af1aba258f5755de8d4c9869d10d70e15be46d32dc7262a33fe81f2ce'
      report = OpenStruct.new(
        mineral_type: 'ORO',
        fine_grams: 52,
        unit: 'gramos',
        base_liquidation_price: 88.87463,
        royalty_percentage: 4,
        total: 181.000,
        period: 4,
        year: "01/01/2016".to_date.strftime("%y"), # ex. 16
        company: seller.company,
        mineral_presentation: 'Amalgama',
        destinations: [buyer.company],
      )
      response = service.call(
        report: report,
        date: '25/11/2016'.to_date.strftime("%Y-%m-%d"),
        signature_picture: signature_picture
      )
      system "mkdir -p #{ Rails.root }/tmp/royalty"
      saved_file = service.file.render_file("#{ Rails.root }/tmp/royalty/royalty_test.pdf")
      file_payload = File.read(saved_file)
      file_hash = Digest::SHA256.hexdigest file_payload
      expect(response[:errors]).to eq []
      expect(response[:success]).to be true
      expect(file_hash).to eq expected_hash
    end
  end
end
