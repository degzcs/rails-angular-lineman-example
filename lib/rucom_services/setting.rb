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
      pp @response
    rescue Exception => e
      @response[:errors] << e.message
      @response
    end  
    


    # def format!(field_names)
      
    # end
  end
end  