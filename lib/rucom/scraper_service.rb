# require 'rubygems'
# require 'mechanize'
# require 'watir-nokogiri'
# require 'pry'

module Rucom

class ScraperService
  URL_PAGE = 'http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf'

  attr_accessor :rucom_page, :data_to_find, :clic_selector

  def initialize(page = nil, data = {}, clic_selector = nil)
    self.rucom_page = page || URL_PAGE
    self.data_to_find = data
    self.clic_selector = clic_selector
  end

  # def call1
  #   agent = Mechanize.new
  #   agent.follow_meta_refresh = true
  #   page = agent.get(@rucom_page)
  #   puts '***************** Printing Page *****************'
  #   pp page
  #   frm = page.form('form')
  #   puts '***************** Printing Form *****************'
  #   pp frm
  #   sleep(2)
  #   puts '***************** set select field Role *****************'
  #   #frm.field_with(:name => 'form:trol_input').options[1].select
  #   pp agent.page.form('form').field_with(:name => 'form:trol_input').options[1].select
  #   sleep(2)
  #   ##pp frm.field_with(:name => 'form:trol_input').options[1]
  #   puts '***************** clic on submit button *****************'
  #   page = agent.page.form('form').submit
  #   puts '***************** New Page *****************'
  #   pp agent.page
  #   pp '************* TEXT Div ******************'
    
  #   pp '************* Begin Search by CSS ******************'
  #   agent.page.search("div#form:tablaListadosANM").each do |item|
  #     #Product.create!(:name => item.text.strip)      
  #     pp item.content    
  #   end
  #   puts "End of service!"
  # end

   def call
    agent = Mechanize.new do |a|
  # Flickr refreshes after login
      a.follow_meta_refresh = true
      a.follow_meta_refresh_self = true
    end
    #agent.follow_meta_refresh = true
    agent.get(@rucom_page) do |page|
      puts '***************** Printing Page *****************'
      pp page
      frm = page.form('form')
      puts '***************** Printing Form *****************'
      pp frm
      sleep(5)
      puts '***************** set select field Role *****************'
      #frm.field_with(:name => 'form:trol_input').options[1].select
      frm.field_with(:name => 'form:trol_input').options[1].select
      pp frm.field_with(:name => 'form:trol_input').options
      sleep(4)
      ##pp frm.field_with(:name => 'form:trol_input').options[1]
      puts '***************** clic on submit button *****************'
      #result = page.form('form').submit
      pp page.form('form').field_with(:name => 'form:trol_input').options[1]
      sleep(2)
      
      result = agent.submit(frm, frm.buttons.first)
      sleep(20)
      binding.pry
      puts '***************** New Page -> result.content *****************'
      pp result
      sleep(2)
      pp '************* TEXT Div ******************'
      
      pp '************* Begin Search by CSS ******************'
      result.search("#form:tablaListadosANM").each do |item|
        #Product.create!(:name => item.text.strip)      
        pp '1-----'
        pp item.content    
      end
      sleep(2)
      puts "End of service!"
    end  
  end
end

rs = ScraperService.new.call
# puts '***************** Inicio Consola *****************'
# URL_PAGE = 'http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf'
# agent = Mechanize.new
# page = agent.get(URL_PAGE)
# pp page
# puts '***************** formulario *****************'
# frm = page.form('form')
# pp frm
# puts '***************** set select field Role *****************'
# frm.field_with(:name => 'form:trol_input').options[1].select
# pp frm.field_with(:name => 'form:trol_input').options[1]
# puts '***************** clic on submit button *****************'
# agent.submit(frm)
end