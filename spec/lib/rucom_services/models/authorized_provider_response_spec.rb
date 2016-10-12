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
        value_5: 'BAREQUERO'
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
        value_5: 'BAREQUERO'
      }
    end

    it 'should validate BAREQUERO is able to trade GOLD' do
      virtus_model = virtus_model_class.new(@parser_result)
      virtus_model.valid?
      expect(virtus_model.errors.full_messages.first).to eq 'Minerals Este productor no puede comercializar ORO'
    end
  end
end
