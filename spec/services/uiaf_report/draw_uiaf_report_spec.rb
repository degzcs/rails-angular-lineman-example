describe UiafReport::DrawUiafReport do
  subject(:service) { UiafReport::DrawUiafReport.new }

  it 'check consistency of the pdf' do
    expected_hash = '8a2dec5318793d415decc6d21bef7a809f61e840f372172e7948866190578346'
    response = service.call(
      test: 'HOLA MUNDO'
    )

    system "mkdir -p #{ Rails.root }/tmp/uiaf_report"
    saved_file = service.file.render_file("#{ Rails.root }/tmp/uiaf_report/uiaf_report.pdf")
    file_payload = File.read(saved_file)
    file_hash = Digest::SHA256.hexdigest file_payload
    expect(response[:success]).to be true
    expect(file_hash).to eq expected_hash
  end
end
