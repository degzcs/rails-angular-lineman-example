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
          errors: [],
          original_name: 'AMADO  MARULANDA',
          name: 'AMADO  MARULANDA',
          minerals: 'ORO',
          localization: 'CORDOBA - PUERTO LIBERTADOR',
          status: nil,
          provider_type: nil
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
          rucom_number: 'RUCOM-20131218132',
          provider_type: nil
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

  it '#downcase_field' do
    str_val = 'ARMANDO CEBALLO'
    response = rs_formater.downcase_field(str_val)
    expect(response).to eq('armando ceballo')
  end

  it '#remove_spaces' do
    str_val = '     ARMANDO CEBALLO      '
    response = rs_formater.remove_spaces(str_val)
    expect(response).to eq('ARMANDO CEBALLO')
  end

  it '#remove_special_characters' do
    str_val = ' AR1MA0ND$O CE|-BA|LLO~ '
    response = rs_formater.remove_special_characters(str_val)
    expect(response).to eq('ARMANDO CEBALLO')
  end

  context '#assign_fields' do
    context 'When send a :authorized_provider_response as key value inside the options' do
      it 'returns the TraderResponse Virtus Model Atributes ' do
        opt = { format: :authorized_provider_response }
        virtus_model_attr = RucomServices::Models::AuthorizedProviderResponse.new.attributes.keys
        expect(rs_formater.assign_fields(opt)).to eq(virtus_model_attr)
      end
    end

    context 'When send a :trader_response as key value inside the options' do
      it 'returns the TraderResponse Virtus Model Atributes ' do
        opt = { format: :trader_response }
        virtus_model_attr = RucomServices::Models::TraderResponse.new.attributes.keys
        expect(rs_formater.assign_fields(opt)).to eq(virtus_model_attr)
      end
    end

    context 'When no send a valid symbol as key value inside the options' do
      it 'returns a nil as answer and sets errors response key with the respective error message ' do
        opt = { format: :whatever }
        msg = "assign_fields: format option doesn't match: #{opt[:format]}"

        expect(rs_formater.assign_fields(opt)).to eq(nil)
        expect(rs_formater.response[:errors]).to include(msg)
      end
    end
  end

  context '#set_response' do
    context 'when send authorized_provider_response as key value' do
      it 'return a hash with the respective virtus model struct and the return values from rucom as pair value' do
        str_html = '<tr>
                      <td role="gridcell"><span style="white-space:normal">AMADO  MARULANDA </span></td>
                      <td role="gridcell"><span style="white-space:normal">ORO</span></td>
                      <td role="gridcell"><span style="white-space:normal">CORDOBA - PUERTO LIBERTADOR</span></td>
                    </tr>'
        response = {
          original_name: nil,
          name: 'AMADO  MARULANDA',
          minerals: 'ORO',
          localization: 'CORDOBA - PUERTO LIBERTADOR',
          provider_type: nil
        }

        virtus_model_attr = RucomServices::Models::AuthorizedProviderResponse.new.attributes.keys
        tds_results_html = Nokogiri::HTML(str_html).children.css('tr > td')

        expect(rs_formater.set_response(virtus_model_attr, tds_results_html)).to eq(response)
      end
    end

    context 'when send trader_response as key value' do
      it 'return a hash with the respective virtus model struct and the return values from rucom as pair value' do
        str_html = '<tr data-ri="56" class="ui-widget-content ui-datatable-even" role="row">
                    <td role="gridcell"><span style="white-space:normal">RUCOM-20131218132</span></td>
                    <td role="gridcell"><span style="white-space:normal">   FUNDICIÓN RAMIREZ ZONA FRANCA S.A.S.</span></td>
                    <td role="gridcell"><span style="white-space:normal">MINERALES DE ORO Y SUS CONCENTRADOS</span></td>
                    <td role="gridcell"><span style="white-space:normal">Certificado</span></td>
                  </tr>'
        response = {
          original_name: nil,
          name: 'FUNDICIÓN RAMIREZ ZONA FRANCA S.A.S.',
          minerals: 'MINERALES DE ORO Y SUS CONCENTRADOS',
          status: 'Certificado',
          rucom_number: 'RUCOM-20131218132',
          provider_type: nil
        }
        virtus_model_attr = RucomServices::Models::TraderResponse.new.attributes.keys
        tds_results_html = Nokogiri::HTML(str_html).children.css('tr > td')

        expect(rs_formater.set_response(virtus_model_attr, tds_results_html)).to eq(response)
      end
    end
  end
end
