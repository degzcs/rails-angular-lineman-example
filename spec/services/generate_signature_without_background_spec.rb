require 'spec_helper'

describe GenerateSignatureWithoutBackground do
  subject(:service) { ::GenerateSignatureWithoutBackground.new }
  context 'generate signature without background' do
    it 'should remove background of the picture' do
      signature_picture_path = "#{Rails.root}/spec/support/images/signature.jpg"
      signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
      timestamp = '1477003578'
      response = service.call(signature_picture, timestamp)
      expect(response).to eq "#{Rails.root}/tmp/signatures/1477003578/signature.png"
    end

    it 'should throw a exception' do
      signature_picture = nil
      response = service.call(signature_picture)
      expect(response[:errors]).to include("Error: undefined method `tempfile' for nil:NilClass")
    end
  end
end
