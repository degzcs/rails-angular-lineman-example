require 'spec_helper'

describe RucomServices::Setting, type: :service do
  let(:file_name) {'rucom_service.cfg.yml'}
  subject(:rss) {RucomServices::Setting.new}
  
  context "When the rucom_service.cfg.yml exist" do
    it '#call' do
      page_url = "http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf"
      res = rss.call

      expect(res[:success]).to be true
    end

    it "has parameters as initials values to the rucom service scraper" do
      rucom_page_url = "http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf"
      res = rss.call
      expect(res[:config]["scraper"]["page_url"]).to eq( rucom_page_url)
    end
  end
  
  context "When the rucom_service.cfg.yml file not exist or not found in the path the rucom_services" do 
    it "raises an error inside the  response variable in the errors key" do
      file_name = "wherever.cfg.yml"
      res = rss.call({yaml_file_name: file_name})
      expect(res[:errors].count).to be(1)
    end
  end

end  
