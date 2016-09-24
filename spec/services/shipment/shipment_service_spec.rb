require 'spec_helper'

describe Shipment::ShipmentService do
  subject(:service) { Shipment::ShipmentService.new }

  context 'a current user with role trader' do
    before :each do
      @current_buyer = create(:user, :with_company, :with_trader_role).company.legal_representative
      @current_seller = @current_buyer.company.legal_representative
      @order = create(:sale)
    end

    it 'should create a pdf shipment (call)' do
      response = service.call(
        current_user: @current_buyer,
        order: @order
      )
      expect(response[:success]).to be true
      expect(@order.reload.shipment.file.path).to match('shipment.pdf')
    end
  end
end
