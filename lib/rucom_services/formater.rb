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
        store_and_raise_error("assign_fields: format option doesn't match: #{options[:format]}")
      end
    end
    
    def format!(field_names)  
      store_and_raise_error("format!: field_names parameter can't be empty") if field_names.blank?
      field_names.each_with_index do |key, index|
        @response[key] = @data[index].content
      end
      @response
    end

    def store_and_raise_error(str_message)
      @response[:errors] << str_message
      raise str_message
    end
  end
end  