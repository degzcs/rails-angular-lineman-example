#  RucomServices::Formater Module Allows to give a format to  returns data from the Rucom page search.
module RucomServices
  # This class set the format to the sent data
  module Formater
    attr_accessor :response

    def remove_spaces_and_remove_special_characters!(data)
      store_and_raise_error("format!: data parameter can't be empty") if data.blank?
      res = {}
      d = data.except(:rucom_number) if data[:rucom_number].present?
      d ||= data
      d.each do |k, v|
        res[k] = remove_spaces(d[k])
        res[k] = remove_special_characters(d[k])
      end
      res[:provider_type] = downcase_field(res[:provider_type])
      res[:rucom_number] = data[:rucom_number] if data[:rucom_number].present?
      res
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
