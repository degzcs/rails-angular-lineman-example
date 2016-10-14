require 'spec_helper'

describe 'Module Formater' do
  let(:dummy_class) { Class.new { include RucomServices::Formater } }

  it 'downcase_field' do
    str_val = 'ARMANDO CEBALLO'
    response = dummy_class.new.downcase_field(str_val)
    expect(response).to eq('armando ceballo')
  end

  it 'remove_spaces' do
    str_val = '     ARMANDO CEBALLO      '
    response = dummy_class.new.remove_spaces(str_val)
    expect(response).to eq('ARMANDO CEBALLO')
  end

  it 'remove_special_characters' do
    str_val = ' AR1MA0ND$O CE|-BA|LLO~ '
    response = dummy_class.new.remove_special_characters(str_val)
    expect(response).to eq('ARMANDO CEBALLO')
  end

  it 'remove_spaces_and_remove_special_characters' do
    parser_result = {
      value_1: '  h_$o-_l|a ',
      value_2: '  IN5VE5RSIO54NES LE5TO54NIA S|.A|$.S.  ',
      value_3: [' O-R||1O'].first,
      value_4: '  Ce$rtificado  ',
      value_5: '  IN5VE5RSIO54NES LE5TO54NIA S|.A|$.S.  '
    }
    expected_response = {
      value_1: 'hola',
      value_2: 'INVERSIONES LETONIA S.A.S.',
      value_3: 'ORO',
      value_4: 'Certificado',
      value_5: 'INVERSIONES LETONIA S.A.S.'
    }
    response = dummy_class.new.remove_spaces_and_remove_special_characters!(parser_result)
    expect(response[:value_1]).to eq expected_response[:value_1]
    expect(response[:value_2]).to eq expected_response[:value_2]
    expect(response[:value_3]).to eq expected_response[:value_3]
    expect(response[:value_4]).to eq expected_response[:value_4]
    expect(response[:value_5]).to eq expected_response[:value_5]
  end

  it 'errors' do
    response = dummy_class.new.remove_spaces_and_remove_special_characters!(nil)
  end
end
