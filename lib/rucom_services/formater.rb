#  RucomServices::Formater Module Allows to give a format to  returns data from the Rucom page search.
module RucomServices
  class Formater
    FIELDS_TRADERS = %i(rucom_number name minerals state)
    FIELDS_AUTORIZED_PROV = %i(name minerals localization)

    attr_accessor :response

    def initialize
      self.response = {}
      self.response[:errors] = []
    end  

    def call(options ={})      
      if options[:data] && options[:format]
        @data = options[:data] 
        format!(assign_fields(options))
      else  
        @response[:errors] << 
          "call: No was send data as parameter when invoqued the method." unless options[:data]
        @response[:errors] << 
          "call: No was send the format Key when invoqued the method." unless options[:format]
        @response
      #fields = (options[:format] == :trader) ? FIELDS_TRADERS : FIELDS_AUTORIZED_PROV
      end
    end  
    
    def assign_fields(options)
      if options[:format] == :trader_response
        FIELDS_TRADERS
      elsif options[:format] == :autorized_provider_response
        FIELDS_AUTORIZED_PROV
      else
        nil
      end
    end
    
    def format!(field_names)
      field_names.each_with_index do |key, index|
        @response[key] = @data[index].content
      end
      @response
    end
  end
end  