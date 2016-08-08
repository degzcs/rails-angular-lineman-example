#  RucomServices::Formater Module Allows to give a format to  returns data from the Rucom page search.
module RucomServices
  # This class set the format to the sent data
  class Formater
    FIELDS_TRADERS = %i(rucom_number name minerals status).freeze
    FIELDS_AUTORIZED_PROV = %i(name minerals location).freeze
    # SPECIAL_CHARACTERS = [0-9,|,$,\^,=,?,@,\:,!,\,,;,\., [[:ascii:]]].freeze
    attr_accessor :response

    def initialize
      self.response = {}
      @response[:errors] = []
    end

    def call(options = {})
      if options[:data].present? && options[:format].present?
        @data = options[:data]
        format!(assign_fields(options))
      else
        @response[:errors] << 'call: No was send data as parameter when invoqued the method.' unless options[:data].present?
        @response[:errors] << 'call: No was send the format Key when invoqued the method.' unless options[:format].present?
        @response
      end
    rescue StandardError => e
      @response[:errors] << "call: Error #{e.message}"
    end

    def assign_fields(options)
      if options[:format] == :trader_response
        FIELDS_TRADERS
      elsif options[:format] == :autorized_provider_response
        FIELDS_AUTORIZED_PROV
      else
        store_and_raise_error("assign_fields: format option doesn't match: #{options[:format]}", false)
        nil
      end
    end

    def format_status_field
      @response[:status].downcase! unless @response[:status].blank?
    end

    def format!(field_names)
      store_and_raise_error("format!: field_names parameter can't be empty") if field_names.blank?
      field_names.each_with_index do |key, index|
        @response[key] = @data[index].content
        remove_spaces(key)
      end
      store_original_and_remove_special_characters_from_name
      format_status_field
      @response
    end

    def store_and_raise_error(str_message, do_raise = true)
      @response[:errors] << str_message
      raise str_message if do_raise
    end

    private

    def remove_spaces(key)
      @response[key].gsub!(/^\s+|\s+$/, '')
    end

    def store_original_and_remove_special_characters_from_name
      @response[:original_name] = @response[:name]
      @response[:name].gsub!(/\p{N}|\p{Sm}|\p{Cc}|\p{Pc}|\p{Sk}|\p{Zp}|\$|\-/, '')
      @response[:name] = @response[:name].strip
      @response
    end
  end
end
