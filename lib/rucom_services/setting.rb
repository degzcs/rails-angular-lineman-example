#  RucomServices::Setting loads the config *.yml file with the values to initiliaze the RucomServices::Scraper.
module RucomServices
  require "yaml"

  class Setting
    YAML_NAME = "rucom_service.cfg.yml"

    def initialize
      @response = {}
      @response[:errors] = []
    end  

    def call(options ={})
      @file_name = options[:yaml_file_name] || YAML_NAME
      @response[:config] = YAML::load_file(File.join(__dir__, @file_name))
      @response[:success] = true if @response[:config]      
      @response[:send_data][:rol_name] = options[:rol_name] || nil
      @response[:send_data][:id_type] = options[:id_type] || nil
      @response[:send_data][:id_number] = options[:id_number] || nil
      pp @response
    rescue Exception => e
      @response[:errors] << e.message
      @response
    end  

    def page_url
      @page_url =
        if @response[:scraper]["page_url"]
          @response[:scraper]["page_url"]
        else
          nil
        end  
    end

    def table_body_id
      @table_body_id = 
        if @response[:scraper]["table_body_id"]
          @response[:scraper]["table_body_id"]
        else
          nil
        end  
    end    

    def driver
      @driver ||= 
        if @response[:scraper]["driver"]
          @response[:scraper]["driver"]
        else
          nil
        end  
    end

    def browser
      @browser ||= 
        if @response[:scraper]["browser"]
          @response[:scraper]["browser"]
        else
          nil
        end  
    end

    def driver_instance
      @driver_instance ||=
        if @driver && @browser
          @driver.constantize.for @browser 
        else
          nil
        end
    end  

    def hidden_elements_id
      @hidden_elements_id =   
        if @response[:config]["hidden_elements_id"]
          @response[:config]["hidden_elements_id"]
        else
          []
        end  
    end     

    def barequero
      @barequero = 
        if @response[:config]["barequero"]
          @response[:config]["barequero"]
        else
          []
        end  
    end  

    def trader
      @trader = 
        if @response[:config]["trader"]
          @response[:config]["trader"]
        else
          []
        end
    end

    # def format!(field_names)
      
    # end
  end
end  