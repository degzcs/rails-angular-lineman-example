#  RucomServices Module Allows to handle all the service to extract the data from de Rucom page.
module RucomServices
  class Scraper
    PAGE_URL = 'http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf'
    HIDDEN_ELEMENTS_ID = {step_0: 'form:trol_panel', step_1: 'form:tIdentificacion_panel', step_2: 'form:numId'}
    SELECT_OPTIONS = %w(Barequero CEDULA NIT)
    TABLE_BODY_ID = "form:tablaListadosANM_data" # "//*[@id='form:tablaListadosANM_data']"

    attr_accessor :rucom_page, :data_to_find

    def initialize(data = {}, page = nil)
      @response = {}
      @response[:errors] = []
      self.rucom_page = page || PAGE_URL      
      self.data_to_find = data #{rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725'}
    end

    def call
      validates_has_required_params_to_execute_service
      driver = Selenium::WebDriver.for :phantomjs
      html_page_data = navigate_and_get_results_from_searching(driver)
      formatted_data = formater_elements(html_page_data)
      virtus_model_name = (@data_to_find[:format].to_sym == :Barequero) ? "BarequeroResponse" : "TraderResponse"
      virtus_model = convert_to_virtus_model(formatted_data, virtus_model_name)
      validate_data(virtus_model, virtus_model_name)
      #response[:success] = persist_data(data_formated)
      driver.quit
    rescue Exception => e 
      puts "RucomService::Scraper.call error : #{e.message}" 
    end  

    def navigate_and_get_results_from_searching(driver)
      driver.navigate.to PAGE_URL
      display_and_select_options_fields(driver)
      button = driver.find_element(:id, 'form:consultar')
      button.click      
      sleep(10)
      #pp driver.page_source
      html_results = Nokogiri::HTML(driver.page_source)
      pp html_results.class
      table_content = html_results.xpath("//*[@id='#{TABLE_BODY_ID}']").children.css('tr > td')
      #pp table_content.each_with_object([]) {|td, obj| obj << td.text }      
    end

    def formater_elements(html_page_data)
      options = {data: html_page_data, format: @data_to_find[:format].to_sym }
      RucomServices::Formater.new.call(options)
    end

    def convert_to_virtus_model(formatted_data, virtus_model_name)
      "RucomServices::#{virtus_model_name}".constantize.new(formatted_data)
    end

    def validate_data(virtus_model, virtus_model_name)
      raise "" 
    rescue Exception => e 
      @response[:errors]  << e.message
    end  

    private

    def validates_has_required_params_to_execute_service
      raise 'You must to provide a rol name option' if @data_to_find[:rol_name].blank?
      raise 'You must to provide a Id type identification option' if @data_to_find[:id_type].blank?
      raise 'You must to provide a Id number value' if @data_to_find[:id_number].blank?
    end

    def display_and_select_options_fields(browser)
      @data_to_find.values.each_with_index do |val, index|        
        display_hidden_element(browser, HIDDEN_ELEMENTS_ID["step_#{index}".to_sym]) if index < 2
        xpath_element = (index < 2) ? "//*[@data-label='#{val}']" : "//*[@id='form:numId']"
        element = browser.find_element(:xpath => xpath_element)
        if SELECT_OPTIONS.include?(val)
          if element.displayed? 
            element.click
            sleep(2)
          else
            puts "Error: Element hidden or can not do click" 
          end  
        else
          element.send_keys("#{val}")
        end  
      end  
    end

    def display_hidden_element(browser, id)
        js_script = "$(\"[id='#{id}']\").css('display', 'block')"
        browser.execute_script(js_script)
    end
  end
end
