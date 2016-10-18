require_relative '../utilities/hash'
module RucomServices
  module Models
    # This Class allows to valid and persist the data from the Formater Service
    class TraderResponse
      include ActiveModel::Model
      include Virtus.model(nullify_blank: true)
      include ::RucomServices::Formater

      attr_accessor :rucom
      attribute :rucom_number, String
      attribute :name, String
      attribute :minerals, Array
      attribute :status, String
      attribute :original_name, String
      attribute :provider_type, String

      # Validations
      validates_presence_of :rucom_number
      validates_presence_of :name
      validates_presence_of :minerals
      validates_presence_of :status
      validates_presence_of :original_name
      validates_presence_of :provider_type

      #
      # Instance Methods
      #

      def initialize(params = {})
        @rucom_number = params[:value_0]
        @name = params[:value_1]
        @minerals = params[:value_2].split(',') unless params[:value_2].blank?
        @status = params[:value_3]
        @original_name = params[:value_1]
        @provider_type = params[:provider_type]
      end

      def format_values!(fields)
        formatted_fields = remove_spaces_and_remove_special_characters!(fields.slice(:minerals, :name, :status))
        formatted_fields[:provider_type] = downcase_field(fields[:provider_type])
        formatted_fields[:rucom_number] = remove_spaces(fields[:rucom_number])
        merge_values(fields, formatted_fields)
      end

      def merge_values(fields, formatted_fields)
        not_formatted_fields = formatted_fields.diff(fields)
        formatted_fields.merge(not_formatted_fields)
      end

      def save
        if valid?
          @rucom = persist!
          true
        else
          false
        end
      end

      private

      def persist!
        fields_mapping = {
          rucom_number: rucom_number,
          name: name,
          minerals: minerals.first, # TODO: update rucom minerals field type to Array
          status: status,
          original_name: original_name,
          provider_type: provider_type
        }
        formatted_values = format_values!(fields_mapping)
        if formatted_values[:minerals].include?('ORO' || 'oro')
          Rucom.create!(formatted_values)
        else
          raise 'Esta compañia no puede comercializar ORO'
        end
      end
    end
  end
end
