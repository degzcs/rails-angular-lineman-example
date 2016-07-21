#  RucomServices::Setting loads the config *.yml file with the values to initiliaze the RucomServices::Scraper.
module RucomServices
  require "yaml"

  class Setting
    YAML_NAME = "rucom_service.cfg.yml"
    attr_accessor :response, :response_class, :page_url, :driver, :browser,
                  :driver_instance, :table_body_id, :hidden_elements_id,
                  :barequero, :trader

    def initialize
      @response = {}
      @response[:errors] = []
    end  

    def call(options={})
      @file_name = options[:yaml_file_name] || YAML_NAME
      @response[:config] = YAML::load_file(File.join(__dir__, @file_name))
      @response[:success] = true if @response[:config]  
      options_data = {
        rol_name: options[:rol_name],
        id_type: options[:id_type],
        id_number: options[:id_number]
      }
      @response.merge!(send_data: options_data)
      #pp @response
      self
    rescue Exception => e
      @response[:errors] << e.message
      self
    end  

    def success
      @success = (@response[:success]) ? true : false
    end  

    def errors
      @errors = @response[:errors]
    end  

    def response_class
      key_rol = @response[:send_data][:rol_name].downcase
      if @response[:config]["scraper"].key?(key_rol)
        @response_class = @response[:config]["scraper"][key_rol]["response_class"]
      else
        @response[:errors] << "response_class: The key no Exist!. Key: #{key_rol}"
        nil
      end
    end  

    def page_url
      @page_url =
        if !@response[:config]["scraper"]["page_url"].blank?
          @response[:config]["scraper"]["page_url"]
        else
          @response[:errors] << "page_url: Should setting up the page_url"
          nil
        end  
    end

    def table_body_id
      @table_body_id = 
        if !@response[:config]["scraper"]["table_body_id"].blank?
          @response[:config]["scraper"]["table_body_id"]
        else
          @response[:errors] << "table_body_id: Should setting up the table_body_id"
          nil
        end  
    end    

    def driver
      @driver = 
        if !@response[:config]["scraper"]["driver"].blank?
          @response[:config]["scraper"]["driver"]
        else
          @response[:errors] << "driver: Should setting up the driver"
          nil
        end  
    end
    
    def browser
      @browser = 
        if !@response[:config]["scraper"]["browser"].blank?
          @response[:config]["scraper"]["browser"]
        else
          @response[:errors] << "browser: Should setting up the browser"
          nil
        end  
    end

    def driver_instance
      @driver_instance ||=
        if driver && browser
          driver.constantize.for browser 
        else
          @response[:errors] << "driver_instance: Should setting up the driver and browser"
          nil
        end
    end  

    def hidden_elements_id
      @hidden_elements_id =   
        if !@response[:config]["scraper"]["hidden_elements_id"].blank?
          @response[:config]["scraper"]["hidden_elements_id"]
        else
          []
        end  
    end     

    def barequero
      @barequero = 
        if !@response[:config]["scraper"]["barequero"].blank?
          @response[:config]["scraper"]["barequero"]["select_options"]
        else
          @response[:errors] << "barequero: Should setting up the barequero/select_options"
          []
        end  
    end  

    def trader
      @trader = 
        if !@response[:config]["scraper"]["trader"].blank?
          @response[:config]["scraper"]["trader"]["select_options"]
        else
          @response[:errors] << "trader: Should setting up the trader/select_options"
          []
        end
    end

    # def format!(field_names)
      
    # end
  end
end  