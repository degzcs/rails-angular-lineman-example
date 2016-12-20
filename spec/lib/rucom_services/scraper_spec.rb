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
      VCR.use_cassette('successful_barequero_rucom_response') do
        rs_scraper = RucomServices::Scraper.new(@data)
        scraper = rs_scraper.call

        expect(scraper.setting.success).to be true

        expect(scraper.response[:errors].count).to be(0)
      end
    end

    context 'When sends a Trader data to search inside Rucom' do
      it 'returns the correct data from Rucom it belongs to the Trader without errors of any kind' do
        VCR.use_cassette('successful_trader_rucom_response') do
          data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900058021' }
          rs_scraper = RucomServices::Scraper.new(data)
          scraper = rs_scraper.call

          expect(scraper.setting.success).to be true

          # if scraper.response[:errors].include?('RucomService::Scraper.call: Net::ReadTimeout')
          #   p 'Timeout error in the conexion, It seems not be enable at this moment this conexion'
          # else
          expect(scraper.response[:errors].count).to be(0)
          # end
        end
      end
    end
  end
  context 'validates method parce_response' do
    it 'validates parce_response of a comercializador' do
      html = '<tr data-ri="56" class="ui-widget-content ui-datatable-even" role="row">
                  <td role="gridcell"><span style="white-space:normal">RUCOM-20131218132</span></td>
                  <td role="gridcell"><span style="white-space:normal">   FUNDICIÓN RAMIREZ ZONA FRANCA S.A.S.</span></td>
                  <td role="gridcell"><span style="white-space:normal">MINERALES DE ORO Y SUS CONCENTRADOS</span></td>
                  <td role="gridcell"><span style="white-space:normal">Certificado</span></td>
                </tr>'
      tds_results_html = Nokogiri::HTML(html).children.css('tr > td')
      response = rss.parce_response(tds_results_html)
      expect(response[:value_0]).to eq 'RUCOM-20131218132'
      expect(response[:value_1]).to eq '   FUNDICIÓN RAMIREZ ZONA FRANCA S.A.S.'
      expect(response[:value_2]).to eq 'MINERALES DE ORO Y SUS CONCENTRADOS'
      expect(response[:value_3]).to eq 'Certificado'
    end

    it 'validates parce_response of a authorized_provider' do
      html = '<tr>
                      <td role="gridcell"><span style="white-space:normal">AMADO  MARULANDA </span></td>
                      <td role="gridcell"><span style="white-space:normal">ORO</span></td>
                      <td role="gridcell"><span style="white-space:normal">CORDOBA - PUERTO LIBERTADOR</span></td>
                    </tr>'
      tds_results_html = Nokogiri::HTML(html).children.css('tr > td')
      response = rss.parce_response(tds_results_html)
      expect(response[:value_0]).to eq 'AMADO  MARULANDA '
      expect(response[:value_1]).to eq 'ORO'
      expect(response[:value_2]).to eq 'CORDOBA - PUERTO LIBERTADOR'
    end
  end
end
