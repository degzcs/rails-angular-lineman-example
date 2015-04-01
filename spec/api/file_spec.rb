describe :v1 do
  context '#download_file' do

    context 'GET' do
      it 'it render the pdf file' do
        get '/api/v1/download_file', {}
        expect(response.status).to eq 200
      end
    end
  end
end