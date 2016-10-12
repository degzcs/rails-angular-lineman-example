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
      expect(virtus_model.name).to eq 'AMADO'
      expect(virtus_model.minerals).to eq ['ORO']
      expect(virtus_model.location).to eq 'COLOMBIA'
      expect(virtus_model.original_name).to eq 'AMADO'
      expect(virtus_model.provider_type).to eq 'BAREQUERO'
    end
  end
end
