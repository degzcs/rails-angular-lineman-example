require 'spec_helper'

describe DiscountCredits do
  subject(:service) { ::DiscountCredits.new }
  let(:company) { create :company }
  before :each do
    @fine_grams = 6.5
  end

  it 'should show message error When an option is not provided ' do
    response = service.call
    expect(response[:success]).to eq false
    expect(response[:errors]).to include 'You must to provide a buyer'
  end

  it 'should show message error When the buyer does not have enough credits' do
    buyer = company.legal_representative
    response = service.call(
      buyer: buyer,
      buyed_fine_grams: @fine_grams
    )
    expect(response[:success]).to eq false
    expect(response[:errors]).to include 'No tienes los suficientes creditos para hacer esta compra'
  end

  it 'should show message error When the buyer i do not have trazoro_services' do
    company.legal_representative.profile.update_column :available_credits, 100
    buyer = company.legal_representative
    response = service.call(
      buyer: buyer,
      buyed_fine_grams: @fine_grams
    )
    expect(response[:success]).to eq false
    expect(response[:errors]).to include 'No cuentas con servicios trazoro'
  end

  it 'should discount credits' do
    trazoro_service = create(:available_trazoro_service, credits: 1.5, reference: 'buy_gold')
    company.legal_representative.profile.update_column :available_credits, 100
    buyer = company.legal_representative
    buyer.setting.trazoro_services << trazoro_service
    response = service.call(
      buyer: buyer,
      buyed_fine_grams: @fine_grams
    )
    expect(response[:success]).to eq true
    expect(service.buyer.profile.available_credits).to eq 90.25
  end

  it 'When the buyer does not have the service buy_gold' do
    trazoro_service = create(:available_trazoro_service, credits: 1.5, reference: 'silver_gold')
    company.legal_representative.profile.update_column :available_credits, 100
    buyer = company.legal_representative
    buyer.setting.trazoro_services << trazoro_service
    response = service.call(
      buyer: buyer,
      buyed_fine_grams: @fine_grams
    )
    expect(response[:success]).to eq false
    expect(response[:errors]).to include 'Usted no cuenta con el servicio de compra de oro trazoro'
  end
end
