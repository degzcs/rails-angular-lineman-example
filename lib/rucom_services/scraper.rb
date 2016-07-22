#  RucomServices Module Allows to handle all the service to extract the data from de Rucom page.
module RucomServices
  class Scraper
    # PAGE_URL = 'http://tramites.anm.gov.co:8080/Portal/pages/consultaListados/anonimoListados.jsf'
    # HIDDEN_ELEMENTS_ID = {step_0: 'form:trol_panel', step_1: 'form:tIdentificacion_panel', step_2: 'form:numId'}
    # SELECT_OPTIONS = %w(Barequero CEDULA NIT)
    # TABLE_BODY_ID = "form:tablaListadosANM_data" # "//*[@id='form:tablaListadosANM_data']"

    attr_accessor :response, :setting, :data_to_find

    def initialize(data={})
      self.response = {}
      self.response[:errors] = []
      #self.rucom_page = page || PAGE_URL  
      self.setting = nil
      self.data_to_find = data #{rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725'}
    end

    def call
      binding.pry
      validates_has_required_params_to_execute_service
      setting_service(@data_to_find)
      raise "Error load settings from rucom_service.cfg.yml file" unless @setting.success
      ##driver = Selenium::WebDriver.for :phantomjs
      binding.pry
      html_page_data = navigate_and_get_results_from_searching(@setting.driver_instance) #(driver)
      formatted_data = formater_elements(html_page_data)
      ##virtus_model_name = (@data_to_find[:format].to_sym == :Barequero) ? "BarequeroResponse" : "TraderResponse"
      binding.pry
      virtus_model_name = @setting.response_class
      virtus_model = convert_to_virtus_model(formatted_data, virtus_model_name)
      validate_data(virtus_model, virtus_model_name)
      #response[:success] = persist_data(data_formated)
      ##driver.quit
      @setting.driver_instance.quit
      #@response
      self
    rescue Exception => e 
      puts "RucomService::Scraper.call error : #{e.message}" 
      @response[:errors] << "RucomService::Scraper.call: #{e.message}"
      #@response
      self
    end  

    def setting_service(data_to_find)
      @setting = RucomServices::Setting.new.call(data_to_find)
    end  

    def navigate_and_get_results_from_searching(driver)
      binding.pry
      driver.navigate.to @setting.page_url ##PAGE_URL
      display_and_select_options_fields(driver)
      ##button = driver.find_element(:id, 'form:consultar')
      button = driver.find_element(:id, @setting.clic_button_id)
      button.click      
      sleep(10)
      #pp driver.page_source
      html_results = Nokogiri::HTML(driver.page_source)
      pp html_results.class
      table_content = 
        html_results.xpath("//*[@id='#{@setting.table_body_id}']").children.css('tr > td')
    end

    def formater_elements(html_page_data)
      options = {data: html_page_data, format: @setting.response_class.to_sym }
      RucomServices::Formater.new.call(options)
    end

    def convert_to_virtus_model(formatted_data, virtus_model_name)
      binding.pry
      "RucomServices::#{virtus_model_name}".constantize.new(formatted_data)
    end

    def validate_data(virtus_model, virtus_model_name)
      raise "" 
    rescue Exception => e 
      @response[:errors]  << e.message
    end  

    private

    def validates_has_required_params_to_execute_service
      @response[:errors]  << 'You must to provide a rol name option' if @data_to_find[:rol_name].blank?
      @response[:errors]  << 'You must to provide a Id type identification option' if @data_to_find[:id_type].blank?
      @response[:errors]  << 'You must to provide a Id number value' if @data_to_find[:id_number].blank?
      msg = 'validates_has_required_params_to_execute_service: Error with sent input data from view'
      raise msg if @response[:errors].count > 0
    end

    def display_and_select_options_fields(browser)
      @data_to_find.values.each_with_index do |val, i|   
        binding.pry     
        display_hidden_element(browser, @setting.hidden_elements_id["step_#{i}"]) if i < 2
        id = @setting.hidden_elements_id["step_#{i}"] if i > 1
        xpath_element = (i < 2) ? "//*[@data-label='#{val}']" : "//*[@id='#{id}']"
       
        raise "can't find the element" \
         "by xpath: #{xpath_element}" unless element = browser.find_element(:xpath => xpath_element)

        rol_name = @setting.response[:send_data][:rol_name].downcase

        if @setting.instance_eval("send(:#{rol_name})").include?(val)
          if element.displayed? 
            element.click
            sleep(2)
          else
            raise "Error: Element hidden or can not do clic #{element}" 
          end  
        else
          element.send_keys("#{val}")
        end  
      end
    rescue Exception => e    
      #@response[:errors] << "display_and_select_options_fields: #{e.message}"
      raise "display_and_select_options_fields: #{e.message}"
    end

    def display_hidden_element(browser, id)
      js_script = "$(\"[id='#{id}']\").css('display', 'block')"
      browser.execute_script(js_script) 
      true
    rescue Exception => e
      raise "display_hidden_element: Error executing script js_script: #{js_script}" 
    end  
  end
end
