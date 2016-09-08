require 'spec_helper'

describe RucomServices::Scraper, type: :service do
  subject(:rss) { RucomServices::Scraper.new }

  before :each do
    @data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
  end

  xit '#initialize' do
    rs_scraper = RucomServices::Scraper.new(@data)
    rs_scraper.call
  end

  xit 'Validates the params from request has values' do
    @data = {}
    expect(rss.data_to_find).to eq({})
  end

  context '#call' do
    context "When didn't send one of the parameters riquered from the view" do
      it "raises and error indicating which parameter didn't send it" do
        msg = 'RucomService::Scraper.call: ' \
          'validates_has_required_params_to_execute_service: Error with sent input data from view'
        scraper = rss.call
        expect(scraper.response[:errors].count).to be > 0
        expect(scraper.response[:errors]).to include(msg)
      end
    end

    context 'When can not load the settings' do
      it 'raises an error' do
        msg = 'RucomService::Scraper.call: Error loading settings from rucom_service.yml file'
        @data[:yaml_file_name] = 'other.yml'
        rs_scraper = RucomServices::Scraper.new(@data)
        scraper = rs_scraper.call

        expect(scraper.response[:errors].count).to be(1)
        expect(scraper.response[:errors]).to include(msg)
      end
    end

    it 'returns a scraper service object whith the response required inside response attribute ' \
      'and whithout errors of any kind' do
      rs_scraper = RucomServices::Scraper.new(@data)
      scraper = rs_scraper.call

      expect(scraper.setting.success).to be true

      if scraper.response[:errors].include?('RucomService::Scraper.call: Net::ReadTimeout')
        p 'Timeout error in the conexion, It seems not be enable at this moment this conexion'
      else
        expect(scraper.response[:errors].count).to be(0)
      end
    end

    context 'When sends a Trader data to search inside Rucom' do
      it 'returns the correct data from Rucom it belongs to the Trader without errors of any kind' do
        data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900058021' }
        rs_scraper = RucomServices::Scraper.new(data)
        scraper = rs_scraper.call

        expect(scraper.setting.success).to be true

        if scraper.response[:errors].include?('RucomService::Scraper.call: Net::ReadTimeout')
          p 'Timeout error in the conexion, It seems not be enable at this moment this conexion'
        else
          expect(scraper.response[:errors].count).to be(0)
        end
      end
    end
  end
end
