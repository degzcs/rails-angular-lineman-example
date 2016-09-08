#  RucomServices::Formater Module Allows to give a format to  returns data from the Rucom page search.
module RucomServices
  # This class set the format to the sent data
  class Formater
    VIRTUS_MODELS_NAMES = %i(authorized_provider_response trader_response).freeze
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
        add_message_errors_to_response(options)
      end
    rescue StandardError => e
      @response[:errors] << "call: Error #{e.message}"
      @response
    end

    def add_message_errors_to_response(options)
      @response[:errors] << 'call: No was send data as parameter when invoqued the method.' unless options[:data].present?
      @response[:errors] << 'call: No was send the format Key when invoqued the method.' unless options[:format].present?
      @response
    end

    def assign_fields(options)
      if VIRTUS_MODELS_NAMES.include?(options[:format])
        virtus_model = Object.const_get "RucomServices::Models::#{options[:format].to_s.camelize}"
        virtus_model.new.attributes.keys
      else
        store_and_raise_error("assign_fields: format option doesn't match: #{options[:format]}", false)
        nil
      end
    end

    def downcase_field(field)
      field.downcase unless field.blank?
    end

    def format!(field_names)
      store_and_raise_error("format!: field_names parameter can't be empty") if field_names.blank?
      rucom_values = set_response(field_names, @data)
      @response.merge!(rucom_values) unless rucom_values.blank?
      @response[:original_name] = @response[:name]
      @response[:name] = remove_special_characters(@response[:name])
      @response[:status] = downcase_field(@response[:status])
      @response
    end

    #
    # field_names => virtus model atributes, example: [:key1, :key2 ...]
    # xml_rucom => data table from rucom, example: Nokogiri::HTML(page_html).children.css('tr > td')
    #
    def set_response(field_names, xml_rucom)
      res = {}
      field_names.each_with_index do |key, index|
        res[key] = xml_rucom[index].present? ? remove_spaces(xml_rucom[index].content) : nil
      end
      res
    end

    def store_and_raise_error(str_message, do_raise = true)
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
