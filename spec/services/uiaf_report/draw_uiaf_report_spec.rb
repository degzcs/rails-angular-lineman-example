describe UiafReport::DrawUiafReport do
  subject(:service) { UiafReport::DrawUiafReport.new }

  before :each do
    @buyer = create(:user, :with_profile, :with_company, first_name: 'Alam', last_name: 'Agudelo')
    Timecop.freeze(2008, 9, 1, 10, 5, 0)
    @purchase_order = create(:purchase, buyer: @buyer)
  end

  after :each do
    Timecop.return
  end

  it 'check consistency of the pdf' do
    expected_hash = '2d6ee6dd0e8e53fb04e81bef9f114f5a607a6c07f23b1dfd847509efaf1b7cb8'
    # @purchase_order.buyer.company.name
    order_presenter = OrderPresenter.new(@purchase_order, nil)
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
