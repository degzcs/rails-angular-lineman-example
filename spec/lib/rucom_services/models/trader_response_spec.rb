require 'spec_helper'

describe RucomServices::Models::TraderResponse do
  subject(:virtus_model_class) { RucomServices::Models::TraderResponse }

  context 'valid model' do
    before :each do
      @parser_result = {
        value_0: 'RUCOM-201403173059',
        value_1: 'INVERSIONES LETONIA S.A.S.',
        value_2: 'ORO',
        value_3: 'Certificado',
        provider_type: 'comercializadores'
      }
    end

    it 'should create a valid virtus model' do
      virtus_model = virtus_model_class.new(@parser_result)
      expect(virtus_model.rucom_number).to eq @parser_result[:value_0]
      expect(virtus_model.name).to eq @parser_result[:value_1]
      expect(virtus_model.minerals.first).to eq @parser_result[:value_2]
      expect(virtus_model.status).to eq @parser_result[:value_3]
      expect(virtus_model.original_name).to eq @parser_result[:value_1]
      expect(virtus_model.provider_type).to eq @parser_result[:provider_type]
    end

    it 'should persist the current virtus model into rucoms table' do
      virtus_model = virtus_model_class.new(@parser_result)
      virtus_model.save
      rucom = virtus_model.rucom
      expect(rucom.persisted?).to eq true
      expect(rucom.rucom_number).to eq @parser_result[:value_0]
      expect(rucom.name).to eq @parser_result[:value_1]
      expect(rucom.minerals).to eq @parser_result[:value_2] # TODO: update rucom#minerals field type to Array
      expect(rucom.status).to eq @parser_result[:value_3]
      expect(rucom.original_name).to eq @parser_result[:value_1]
      expect(rucom.provider_type).to eq @parser_result[:provider_type]
    end
  end

  context 'validations' do
    before :each do
      @parser_result = {
        value_0: 'RUCOM-201403173059',
        value_1: 'INVERSIONES LETONIA S.A.S.',
        value_2: 'PLATA',
        value_3: 'Certificado',
        provider_type: 'Comercializadores'
      }
    end

    it 'should validate comercializadores is able to trade GOLD' do
      virtus_model = virtus_model_class.new(@parser_result)
      expect { virtus_model.save }.to raise_error('Esta compañia no puede comercializar ORO')
    end
  end

  context 'format data' do
    it 'should formated all the fields' do
      @parser_result = {
        value_0: '  RUCOM-201403173059 ',
        value_1: '  IN5VE5RSIO54NES LE5TO54NIA S|.A|$.S.  ',
        value_2: ' O-R||1O',
        value_3: '  Ce$rtificado  ',
        provider_type: 'Comercializadores'
      }
      expected_response = {
        rucom_number: 'RUCOM-201403173059',
        name: 'INVERSIONES LETONIA S.A.S.',
        minerals: 'ORO',
        status: 'Certificado',
        original_name: '  IN5VE5RSIO54NES LE5TO54NIA S|.A|$.S.  ',
        provider_type: 'comercializadores'
      }
      virtus_model = virtus_model_class.new(@parser_result)
      virtus_model.save
      expect(virtus_model.rucom.persisted?).to eq true
      expect(virtus_model.rucom.rucom_number).to eq expected_response[:rucom_number]
      expect(virtus_model.rucom.name).to eq expected_response[:name]
      expect(virtus_model.rucom.minerals).to eq expected_response[:minerals]
      expect(virtus_model.rucom.status).to eq expected_response[:status]
      expect(virtus_model.rucom.original_name).to eq expected_response[:original_name]
      expect(virtus_model.rucom.provider_type).to eq expected_response[:provider_type]
    end
  end
end
