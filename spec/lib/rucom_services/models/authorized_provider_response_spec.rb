require 'spec_helper'

describe RucomServices::Models::AuthorizedProviderResponse do
  let(:virtus_model_class) { RucomServices::Models::AuthorizedProviderResponse }

  context 'valid model' do
    before :each do
      @parser_result = {
        value_1: 'AMADO',
        value_2: ['ORO'],
        value_3: 'COLOMBIA',
        value_4: 'AMADO',
        value_5: 'barequero'
      }
    end

    it 'should create a valid virtus model' do
      virtus_model = virtus_model_class.new(@parser_result)
      expect(virtus_model.name).to eq @parser_result[:value_1]
      expect(virtus_model.minerals).to eq @parser_result[:value_2]
      expect(virtus_model.location).to eq @parser_result[:value_3]
      expect(virtus_model.original_name).to eq @parser_result[:value_4]
      expect(virtus_model.provider_type).to eq @parser_result[:value_5]
    end

    it 'should persist the current virtus model into rucoms table' do
      virtus_model = virtus_model_class.new(@parser_result)
      virtus_model.save
      rucom = virtus_model.rucom
      expect(rucom.persisted?).to eq true
      expect(rucom.name).to eq @parser_result[:value_1]
      expect(rucom.minerals).to eq @parser_result[:value_2].first # TODO: update rucom#minerals field type to Array
      expect(rucom.location).to eq @parser_result[:value_3]
      expect(rucom.original_name).to eq @parser_result[:value_4]
      expect(rucom.provider_type).to eq @parser_result[:value_5]
    end
  end

  context 'validations' do
    before :each do
      @parser_result = {
        value_1: 'AMADO',
        value_2: ['PLATA'],
        value_3: 'COLOMBIA',
        value_4: 'AMADO',
        value_5: 'Barequero'
      }
    end

    it 'should validate Barequero is able to trade GOLD' do
      virtus_model = virtus_model_class.new(@parser_result)
      virtus_model.save
      expect(virtus_model.errors.full_messages).to include('Minerals Este productor no puede comercializar ORO')
    end
  end

  context 'format data' do
    it 'should formated all the fields' do
      @parser_result = {
        value_1: '  AR1MA0ND$O CE|-BA|LLO~ ',
        value_2: [' O-R||1O'],
        value_3: ' CO54RD$OBA - PUER|TO LIBE-|R|T$AD1OR   ',
        value_4: '  AR1MA0ND$O CE|-BA|LLO~ ',
        value_5: 'Barequero'
      }
      expected_response = {
        name: 'ARMANDO CEBALLO',
        minerals: 'ORO',
        location: 'CORDOBA  PUERTO LIBERTADOR',
        original_name: '  AR1MA0ND$O CE|-BA|LLO~ ',
        provider_type: 'barequero'
      }
      virtus_model = virtus_model_class.new(@parser_result)
      virtus_model.save
      expect(virtus_model.rucom.persisted?).to eq true
      expect(virtus_model.rucom.name).to eq expected_response[:name]
      expect(virtus_model.rucom.minerals).to eq expected_response[:minerals]
      expect(virtus_model.rucom.location).to eq expected_response[:location]
      expect(virtus_model.rucom.original_name).to eq expected_response[:original_name]
      expect(virtus_model.rucom.provider_type).to eq expected_response[:provider_type]
    end
  end
end
