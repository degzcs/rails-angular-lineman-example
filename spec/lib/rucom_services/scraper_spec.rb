require 'spec_helper'

describe RucomServices::Scraper, type: :service do
  before :each do
    @data = {rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725'}
  end

  it '#initialize' do
    rss = RucomServices::Scraper.new(@data)
    rss.call
  end

  it 'Validates the params from request has values' do
    @data = {}
    rss = RucomServices::Scraper.new
    expect(rss.data_to_find).to eq({})
  end  

end  

