#  RucomServices::Formater Module Allows to give a format to  returns data from the Rucom page search.
module RucomServices
  # This class set the format to the sent data
  module Formater
    attr_accessor :response

    def remove_spaces_and_remove_special_characters!(data)
      store_and_raise_error("format!: data parameter can't be empty") if data.blank?
      formatted_values = {}
      data.each do |k, v|
        formatted_values[k] = remove_spaces(data[k])
        formatted_values[k] = remove_special_characters(data[k])
      end
      formatted_values
    end

    def downcase_field(field)
      field.downcase unless field.blank?
    end

    def store_and_raise_error(str_message, do_raise = true)
      @response[:errors] = []
      @response[:errors] << str_message
      raise str_message if do_raise
    end

    def remove_special_characters(field_val)
      without_special = field_val.gsub(/\p{N}|\p{Sm}|\p{Cc}|\p{Pc}|\p{Sk}|\p{Zp}|\$|\-/, '') unless field_val.blank?
      without_special.strip unless field_val.blank?
    end

    def remove_spaces(value)
      value.blank? ? value : value.gsub(/^\s+|\s+$/, '')
    end
  end
end
