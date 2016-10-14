module RucomServices
  module Models
    # The  Autorized providers are: Chatarreros and Barequeros
    class AuthorizedProviderResponse
      include ActiveModel::Model
      include Virtus.model(nullify_blank: true)
      include ::RucomServices::Formater

      attr_accessor :rucom
      attribute :name, String
      attribute :minerals, Array
      attribute :location, String
      attribute :original_name, String
      attribute :provider_type, String

      # Validations
      validates_presence_of :name
      validates_presence_of :minerals
      validates_presence_of :original_name
      validates_presence_of :provider_type
      validates_presence_of :location

      #
      # Instance Methods
      #

      def initialize(params = {})
        @name = params[:value_1]
        @minerals = params[:value_2]
        @location = params[:value_3]
        @original_name = params[:value_4]
        @provider_type = params[:value_5]
      end

      def format_values!(fields)
        self.remove_spaces_and_remove_special_characters!(fields)
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
        # Status: values = 'Activo' | 'Inactivo'
        # This field dosen't return from rucom it will be set as:
        # 'Activo' when appears in the rucom database otherwise
        fields_mapping = {
          name: name,
          minerals: minerals.first, # TODO: update rucom#minerals field type to Array
          location: location,
          status: 'Activo',
          original_name: original_name,
          provider_type: provider_type
        }
        formatted_values = format_values!(fields_mapping)
        if formatted_values[:minerals].include?('ORO' || 'oro')
          Rucom.create!(formatted_values)
        else
          errors.add(:minerals, 'Este productor no puede comercializar ORO')
        end
      end
    end
  end
end
