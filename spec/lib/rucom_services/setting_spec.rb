require 'spec_helper'

describe RucomServices::Setting, type: :service do
  let(:file_name) { 'rucom_service.cfg.yml' }
  subject(:rs_setting) { RucomServices::Setting.new }
  page = 'http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf'
  let(:rucom_page_url) { page }

  context 'When the rucom_service.cfg.yml file not exist or not found in the path the rucom_services' do
    it 'raises an error inside the  response variable in the errors key' do
      file_name = 'wherever.cfg.yml'
      cfg = rs_setting.call(yaml_file_name: file_name)

      expect(cfg.response[:errors].count).to be(1)
      expect(cfg.response[:errors].first).to match(/No such file or directory @ rb_sysopen/)
    end
  end

  context 'When the rucom_service.cfg.yml exist' do
    let(:cfg) { rs_setting.call }

    it 'has parameters as initials values to the rucom service scraper' do
      expect(cfg.response[:config]['scraper']['page_url']).to eq(rucom_page_url)
    end

    it '#page_url' do
      expect(cfg.page_url).to eq(rucom_page_url)
    end

    context '#driver' do
      it '#driver' do
        expect(cfg.driver).to include('Selenium::WebDriver') if cfg.driver
      end

      context 'When doesn\'t have set a driver' do
        it 'returns nil and set an error inside response object' do
          unless cfg.driver
            err_msg = 'driver: Should setting up the driver'

            expect(cfg.driver).to eq(nil)
            expect(cfg.response[:errors].first).to eq(err_msg)
          end
        end
      end
    end

    it '#success' do
      expect(cfg.success).not_to eq(nil)
    end

    context 'When calling the Setting service whith send data from frontend' do
      let(:data) { { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' } }
      let(:cfg1) { rs_setting.call(data) }

      it '#call' do
        expect(cfg1.response[:success]).to be true
      end

      it 'storages the values inside response in a key(hash) called send_data' do
        expect(cfg1.response[:send_data][:rol_name]).to eq 'Barequero'
        expect(cfg1.response[:send_data][:id_type]).to eq 'CEDULA'
        expect(cfg1.response[:send_data][:id_number]).to eq '15535725'
      end
    end

    it '#browser' do
      expect(cfg.browser).to eq(:phantomjs)
    end

    it '#hidden_elements_id' do
      elements = {
        'step_0' => 'form:trol_panel',
        'step_1' => 'form:tIdentificacion_panel',
        'step_2' => 'form:numId'
      }
      expect(cfg.hidden_elements_id).to eq(elements)
    end

    it '#table_body_id' do
      expect(cfg.table_body_id).to eq('form:tablaListadosANM_data')
    end

    it '#response_class' do
      data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
      cfg1 = rs_setting.call(data)
      expect(cfg1.response_class).to eq('AuthorizedProviderResponse')

      data[:rol_name] = 'Trader'
      cfg1 = rs_setting.call(data)
      expect(cfg1.response_class).to eq('TraderResponse')
    end

    context 'when the rol_name key no exist in the rucom_service.cfg.yml' do
      it 'returns nil and an error inside response[:errors] array' do
        data = { rol_name: 'Comerciante', id_type: 'CEDULA', id_number: '15535725' }
        cfg1 = rs_setting.call(data)

        expect(cfg1.response_class).to eq(nil)
        expect(cfg1.response[:errors].count).to eq(1)
        expect(cfg1.response[:errors].first).to match('response_class: The key no Exist!. Key:')
      end
    end

    it '#driver_instance' do
      expect(cfg.driver_instance.class).to eq(Selenium::WebDriver::Driver)
    end

    it '#barequero' do
      expect(cfg.barequero.class).to eq(Array)
      expect(cfg.barequero.blank?).not_to eq(true)
    end

    it '#trader' do
      expect(cfg.trader.class).to eq(Array)
      expect(cfg.trader.blank?).not_to eq(true)
    end

    it '#clic_button_id' do
      if cfg.clic_button_id
        expect(cfg.clic_button_id.class).to eq(String)
      else
        expect(cfg.response[:errors].count).to eq(1)
        expect(cfg.response[:errors].first).to eq('clic_button_id: Should set up clic_button_id')
      end
    end

    it '#wait_load' do
      expect(cfg.wait_load.class).to eq(Fixnum)
    end

    it '#wait_clic' do
      expect(cfg.wait_clic.class).to eq(Fixnum)
    end
  end
end
