#  RucomServices::Formater Module Allows to give a format to  returns data from the Rucom page search.
module RucomServices
  class Formater
    FIELDS_TRADERS = %i(rucom_number name minerals state)
    FIELDS_AUTORIZED_PROV = %i(name minerals localization)

    def initialize
      self.response = {}
      self.response[:errors] = []
    end  

    def call(options ={})
      @data = options[:data]
      fields = (options[:format] == :trader) ? FIELDS_TRADERS : FIELDS_AUTORIZED_PROV
      format!(fields)
    end  
    
    def format!(field_names)
      field_names.each_with_index do |key, index|
        response[key] = @data[index].content
      end
      response
    end
  end
end  