describe UiafReport::DrawUiafReport do
  subject(:service) { UiafReport::DrawUiafReport.new }

  let(:seller) { create :user, :with_profile, :with_personal_rucom, provider_type: 'Barequero', first_name: 'Alam', last_name: 'Agudelo' }
  let(:purchase_order) { create :purchase, seller: seller }

  it 'check consistency of the pdf' do
    expected_hash = '45fc7e97a1d6793f0d1cd839cab250dcd6d708f360bdb522f69394f4b197bfde'
    order_presenter = OrderPresenter.new(purchase_order, nil)
    response = service.call(
      order_presenter: order_presenter
    )

    system "mkdir -p #{ Rails.root }/tmp/uiaf_report"
    saved_file = service.file.render_file("#{ Rails.root }/tmp/uiaf_report/uiaf_report.pdf")
    file_payload = File.read(saved_file)
    file_hash = Digest::SHA256.hexdigest file_payload
    expect(response[:success]).to be true
    expect(file_hash).to eq expected_hash
  end
end
