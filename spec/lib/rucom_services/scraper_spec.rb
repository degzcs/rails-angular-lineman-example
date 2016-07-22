require 'spec_helper'

describe RucomServices::Scraper, type: :service do
  subject(:rss) { RucomServices::Scraper.new }

  before :each do
    @data = {rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725'}
  end

  xit '#initialize' do
    rs_scraper = RucomServices::Scraper.new(@data)
    rs_scraper.call
  end

  xit 'Validates the params from request has values' do
    @data = {}
    expect(rss.data_to_find).to eq({})
  end  

  context "#call" do
    context "When didn't send one of the parameters riquered from the view" do
      it "raises and error indicating which parameter didn't send it" do
        msg = 'RucomService::Scraper.call: ' \
          'validates_has_required_params_to_execute_service: Error with sent input data from view'
        expect(rss.call.response[:errors].count).to be > 0
        expect(rss.call.response[:errors]).to include(msg)
      end
    end

    context "When can not load the settings" do
      xit "raises an error" do
        msg = "RucomService::Scraper.call: Error load settings from rucom_service.cfg.yml file"
        scraper = rss.call(@data)
        #if scraper.setting.success
          expect(rss.call.response[:errors].count).to be( 1)
          expect(rss.call.response[:errors]).to include(msg)
        #end
      end  
    end  
  end

end  

