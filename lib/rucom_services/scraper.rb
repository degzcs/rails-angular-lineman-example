module RucomServices
  #  RucomServices Module Allows to handle all the service to extract the data from de Rucom page.
  class Scraper
    attr_accessor :response, :setting, :data_to_find, :virtus_model, :is_there_rucom
    VIRTUS_MODELS_TYPES = %i(authorized_provider_response trader_response).freeze

    def initialize(data = {})
      self.response = {}
      @response[:errors] = []
      self.setting = nil
      # TODO: rol_name has to change to role_name or provider_type.
      self.data_to_find = data # {rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725'}
      self.is_there_rucom = false
      @virtus_model = nil
    end

    def call
      validates_has_required_params_to_execute_service
      setting_service(@data_to_find)
      raise 'Error loading settings from rucom_service.yml file' unless @setting.success
      html_page_data = navigate_and_get_results_from_searching(@setting.driver_instance)
      @is_there_rucom = validate_got_results(html_page_data)
      parced_data = @is_there_rucom ? parce_response(html_page_data) : []
      # NOTE: this line fix correct provider_type assignament, however this have to be changed
      # along with the formatted feature
      if parced_data.present?
        parced_data[:provider_type] = @data_to_find[:rol_name]
        virtus_model_name = @setting.response_class
        @virtus_model = convert_to_virtus_model(parced_data, virtus_model_name)
        @setting.driver_instance.quit
      end
      self
    rescue StandardError => e
      @response[:errors] << "RucomService::Scraper.call: #{e.message}"
      self
    end

    def setting_service(data_to_find)
      @setting = RucomServices::Setting.new.call(data_to_find)
    end

    # @return [ Nokogiri::XML::NodeSet ]
    def navigate_and_get_results_from_searching(driver)
      driver.navigate.to @setting.page_url
      display_and_select_options_fields(driver)
      button = driver.find_element(:id, @setting.clic_button_id)
      button.click
      sleep(@setting.wait_load)
      html_results = Nokogiri::HTML(driver.page_source)
      html_results.xpath("//*[@id='#{@setting.table_body_id}']").children.css('tr > td')
    end

    # Parse the rucom html data into a hash
    # @param html_page_data
    # @return [ Hash ] in the next form
    #     {
    #       value_0: 'Barequero name',
    #       value_1: 'mineral name',
    #       ...
    #     }
    def parce_response(html_page_data)
      res = {}
      html_page_data.each_with_index do |nokogiri_element, index|
        res["value_#{ index }".to_sym] = nokogiri_element.content
      end
      res
    end

    # @param parced_data [ Hash ]
    # @param virtus_model_name [ String ]
    def convert_to_virtus_model(parced_data, virtus_model_name)
      virtus_model = Object.const_get "RucomServices::Models::#{virtus_model_name}"
      parced_data.blank? || parced_data.class != Hash ? virtus_model.new : virtus_model.new(parced_data)
    end

    def validate_got_results(html_results)
      html_results.text.present?
    end

    private

    def validates_has_required_params_to_execute_service
      msg = 'You must to provide a '
      @response[:errors] << msg + 'rol name option' if @data_to_find[:rol_name].blank?
      @response[:errors] << msg + 'Id type identification option' if @data_to_find[:id_type].blank?
      @response[:errors] << msg + 'Id number value' if @data_to_find[:id_number].blank?
      msg = 'validates_has_required_params_to_execute_service: Error with sent input data from view'
      raise msg if @response[:errors].count > 0
    end

    def display_and_select_options_fields(browser)
      @setting.send_data.values.each_with_index do |val, i|
        display_hidden_element(browser, @setting.hidden_elements_id["step_#{i}"]) if i < 2
        id = @setting.hidden_elements_id["step_#{i}"] if i > 1
        xpath_element = i < 2 ? "//*[@data-label='#{val}']" : "//*[@id='#{id}']"

        raise "can't find the element" \
         "by xpath: #{xpath_element}" unless (element = browser.find_element(xpath: xpath_element))
        rol_name = @setting.role_name.downcase
        raise "Valor enviado desconocido, rol_name: #{response[:send_data][:rol_name]}" if rol_name == 'unknown'

        if @setting.instance_eval("send(:#{rol_name})").include?(val)
          if element.displayed?
            element.click
            sleep(@setting.wait_clic)
          else
            raise "Error: Element hidden or can not do clic #{element}"
          end
        else
          element.send_keys(val)
        end
      end
    rescue StandardError => e
      raise "display_and_select_options_fields: #{e.message}"
    end

    def display_hidden_element(browser, id)
      # js_script = "$(\"[id='#{id}']\").css('display', 'block')"  -> this is another way using jquery
      element = browser.find_element(:id, id)
      browser.execute_script("arguments[0].style.display='block';", element) if element.present?
      true
    rescue StandardError => e
      raise "display_hidden_element: Error executing script with element: #{id} #{e.message}"
    end
  end
end
