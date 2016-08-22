require 'spec_helper'

describe RucomServices::Formater, type: :service do
  subject(:rs_formater) { RucomServices::Formater.new }

  it '#initialize' do
    # rss = RucomServices::Formater.new
    expect(rs_formater.response.class).to eq(Hash)
    expect(rs_formater.response[:errors]).to eq([])
  end

  context '#call' do
    context 'when sends autorized_provider_response key as format value ' do
      it 'returns its respective virtus model' do
        str_html = '<tr><td role="gridcell"><span style="white-space:normal">AMADO  MARULANDA </span></td>
                      <td role="gridcell"><span style="white-space:normal">ORO</span></td>
                      <td role="gridcell"><span style="white-space:normal">CORDOBA - PUERTO LIBERTADOR</span></td>
                    </tr>'
        response = {
          original_name: 'AMADO  MARULANDA',
          name: 'AMADO  MARULANDA',
          minerals: 'ORO',
          location: 'CORDOBA - PUERTO LIBERTADOR',
          errors: []
        }

        tds_results_html = Nokogiri::HTML(str_html).children.css('tr > td')
        options = { data: tds_results_html, format: :authorized_provider_response }

        expect(rs_formater.call(options)).to eq(response)
      end
    end

    context 'when sends trader_response key as format value ' do
      it 'returns its respective virtus model' do
        str_html = '<tr data-ri="56" class="ui-widget-content ui-datatable-even" role="row">
                    <td role="gridcell"><span style="white-space:normal">RUCOM-20131218132</span></td>
                    <td role="gridcell"><span style="white-space:normal">   FUNDICIÓN RAMIREZ ZONA FRANCA S.A.S.</span></td>
                    <td role="gridcell"><span style="white-space:normal">MINERALES DE ORO Y SUS CONCENTRADOS</span></td>
                    <td role="gridcell"><span style="white-space:normal">Certificado</span></td>
                  </tr>'
        response = {
          errors: [],
          original_name: 'FUNDICIÓN RAMIREZ ZONA FRANCA S.A.S.',
          name: 'FUNDICIÓN RAMIREZ ZONA FRANCA S.A.S.',
          minerals: 'MINERALES DE ORO Y SUS CONCENTRADOS',
          status: 'certificado',
          rucom_number: 'RUCOM-20131218132'
        }

        tds_results_html = Nokogiri::HTML(str_html).children.css('tr > td')
        options = { data: tds_results_html, format: :trader_response }

        expect(rs_formater.call(options)).to eq(response)
      end
    end

    context 'When no send data or/and format key' do
      it 'returns errors inside reponse[errors] array' do
        str_html = '<tr>
                      <td role="gridcell"><span style="white-space:normal">AMADO  MARULANDA </span></td>
                      <td role="gridcell"><span style="white-space:normal">ORO</span></td>
                      <td role="gridcell"><span style="white-space:normal">CORDOBA - PUERTO LIBERTADOR</span></td>
                    </tr>'
        options = { data: nil, format: :authorized_provider_response }
        error_msg = 'call: No was send data as parameter when invoqued the method.'
        tds_results_html = Nokogiri::HTML(str_html).children.css('tr > td')
        expect(rs_formater.call(options)[:errors]).to include(error_msg)

        options = { data: tds_results_html, format: nil }
        error_msg = 'call: No was send the format Key when invoqued the method.'
        expect(rs_formater.call(options)[:errors]).to include(error_msg)

        options = {}
        error2_msg = error_msg
        error_msg = 'call: No was send data as parameter when invoqued the method.'
        expect(rs_formater.call(options)[:errors]).to include(error_msg, error2_msg)
      end
    end
  end

  context '#assign_fields' do
    context 'When format key value is autorized_provider_response' do
      it 'returns the fields of the autorized_provider_response' do
        fields_autorized_prov = %i(name minerals location)
        options = { data: nil, format: :authorized_provider_response }

        expect(rs_formater.assign_fields(options)).to eq(fields_autorized_prov)
      end
    end

    context 'When format key value is trader_response' do
      it 'returns the fields of the trader_response' do
        fields_trader = %i(rucom_number name minerals status)
        options = { data: nil, format: :trader_response }

        expect(rs_formater.assign_fields(options)).to eq(fields_trader)
      end
    end

    context 'When format key value is another key' do
      it 'raises an error and add the error inside errors response array' do
        options = { data: nil, format: :other_thing }
        expect(rs_formater.assign_fields(options)).to eq(nil)
        expect(rs_formater.response[:errors]).to include(/assign_fields: format option doesn't match\:/)
      end
    end
  end

  xit '#remove_spaces' do
  end
end
