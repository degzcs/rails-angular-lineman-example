require 'spec_helper'

describe RucomServices::Setting, type: :service do
  let(:file_name) {'rucom_service.cfg.yml'}
  subject(:rs_setting) {RucomServices::Setting.new}
  let(:rucom_page_url){ "http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf"}
  
  context "When the rucom_service.cfg.yml file not exist or not found in the path the rucom_services" do 
    it "raises an error inside the  response variable in the errors key" do
      file_name = "wherever.cfg.yml"
      cfg = rs_setting.call({yaml_file_name: file_name})

      expect(cfg.response[:errors].count).to be(1)
      expect(cfg.response[:errors].first).to match(/No such file or directory @ rb_sysopen/)
    end
  end

  context "When the rucom_service.cfg.yml exist" do
    it "has parameters as initials values to the rucom service scraper" do
      cfg = rs_setting.call
      expect(cfg.response[:config]["scraper"]["page_url"]).to eq( rucom_page_url)
    end

    it "#page_url" do
      cfg =  rs_setting.call
      expect(cfg.page_url).to eq(rucom_page_url)
    end

    context "#driver" do
      it "#driver" do
        cfg =  rs_setting.call        
        expect(cfg.driver).to include("Selenium::WebDriver") if cfg.driver
      end

      context "When doesn't have set a driver" do
        it "returns nil and set an error inside response object" do
          cfg =  rs_setting.call
          
          unless cfg.driver
            err_msg = "driver: Should setting up the driver"

            expect(cfg.driver).to eq(nil)
            expect(cfg.response[:errors].first).to eq(err_msg)
          end  
        end
      end
    end

    it '#success' do
      cfg = rs_setting.call
      expect(cfg.success).not_to eq(nil)
    end

    it '#call' do
      cfg = rs_setting.call

      expect(cfg.response[:success]).to be true
    end

    it "#browser" do
      cfg = rs_setting.call
      expect(cfg.browser).to eq(:phantomjs)
    end

    it "#hidden_elements_id" do
      cfg = rs_setting.call
      elements = {
        "step_0"=> "form:trol_panel", 
        "step_1"=> "form:tIdentificacion_panel", 
        "step_2"=> "form:numId"
      }
      expect(cfg.hidden_elements_id).to eq(elements)
    end

    it "#table_body_id" do
      cfg = rs_setting.call
      expect(cfg.table_body_id).to eq("form:tablaListadosANM_data")
    end

    it "#response_class" do
      data = {rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725'}
      cfg = rs_setting.call(data)
      if cfg.response[:send_data][:rol_name] == "Barequero"
        expect(cfg.response_class).to eq("AutorizedProviderResponse")
      else
         expect(cfg.response_class).to eq("TraderResponse") 
      end
    end
  end
end
