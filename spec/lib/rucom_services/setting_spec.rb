require 'spec_helper'

describe RucomServices::Setting, type: :service do
  subject(:rs_setting) { RucomServices::Setting.new }
  page = 'http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf'
  let(:file_name) { 'rucom_service.yml' }
  let(:rucom_page_url) { page }

  context 'When the rucom_service.yml file not exist or not found in the path the rucom_services' do
    it 'raises an error inside the  response variable in the errors key' do
      file_name = 'wherever.yml'
      cfg = rs_setting.call(yaml_file_name: file_name)

      expect(cfg.response[:errors].count).to be(1)
      expect(cfg.response[:errors].first).to match(/No such file or directory @ rb_sysopen/)
    end
  end

  context 'When the rucom_service.yml exist' do
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

      data[:rol_name] = 'Comercializadores'
      cfg1 = rs_setting.call(data)
      expect(cfg1.response_class).to eq('TraderResponse')
    end

    context 'when the rol_name key no exist in the rucom_service.yml' do
      it 'returns nil and an error inside response[:errors] array' do
        data = { rol_name: 'Comerciante', id_type: 'CEDULA', id_number: '15535725' }
        cfg1 = rs_setting.call(data)

        expect(cfg1.response_class).to eq(nil)
        expect(cfg1.response[:errors].count).to eq(1)
        expect(cfg1.response[:errors].first).to match('response_class: The key no Exist!. Key:')
      end
    end

    it '#driver_instance' do
      VCR.use_cassette('settings_driver_instance_class') do
        expect(cfg.driver_instance.class).to eq(Selenium::WebDriver::Driver)
        expect(cfg.driver_instance.quit).to eq(nil)
      end
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

    context '#role_name' do
      context 'when is sent a Barequero as rol_name' do
        it 'returns barequero string as answer' do
          data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
          cfg1 = rs_setting.call(data)

          expect(cfg1.role_name.class).to eq(String)
          expect(cfg1.role_name).to eq('barequero')
        end
      end

      context 'when is sent a Comercializadores as rol_name' do
        it 'returns trader string as answer' do
          data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900058021' }
          cfg1 = rs_setting.call(data)

          expect(cfg1.role_name.class).to eq(String)
          expect(cfg1.role_name).to eq('trader')
        end
      end

      context 'when is sent a different word as rol_name' do
        it 'returns unknown string as answer' do
          data = { rol_name: 'Comerciante', id_type: 'NIT', id_number: '900058021' }
          cfg1 = rs_setting.call(data)

          expect(cfg1.role_name.class).to eq(String)
          expect(cfg1.role_name).to eq('unknown')
        end
      end
    end

    it '#ordering_options' do
      opts = {
        id_number: '1234567',
        rol_name: 'Comercializadores',
        id_type: 'NIT'
      }

      result = {
        rol_name: 'Comercializadores',
        id_type: 'NIT',
        id_number: '1234567'
      }

      response = rs_setting.ordering_options(opts)

      expect(response.keys[0]).to eq(result.keys[0])
      expect(response.values[0]).to eq(result.values[0])

      expect(response.keys[1]).to eq(result.keys[1])
      expect(response.values[1]).to eq(result.values[1])

      expect(response.keys[2]).to eq(result.keys[2])
      expect(response.values[2]).to eq(result.values[2])
    end

    it '#send_data' do
      data = { id_type: 'NIT', id_number: '900058021', rol_name: 'Comerciante' }
      cfg1 = rs_setting.call(data)
      result = { rol_name: 'Comerciante', id_type: 'NIT', id_number: '900058021' }

      expect(cfg1.send_data).to eq(result)

      expect(cfg1.send_data.keys[0]).to eq(result.keys[0])
      expect(cfg1.send_data.values[0]).to eq(result.values[0])

      expect(cfg1.send_data.keys[1]).to eq(result.keys[1])
      expect(cfg1.send_data.values[1]).to eq(result.values[1])

      expect(cfg1.send_data.keys[2]).to eq(result.keys[2])
      expect(cfg1.send_data.values[2]).to eq(result.values[2])
    end
  end
end
