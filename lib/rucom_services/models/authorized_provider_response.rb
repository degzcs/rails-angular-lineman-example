module RucomServices
  module Models
    # The  Autorized providers are: Chatarreros and Barequeros
    class AuthorizedProviderResponse
      include ActiveModel::Model
      include Virtus.model(nullify_blank: true)
      include ::RucomServices::Formater

      # before_save :format_values!

      attr_accessor :rucom
      attribute :name, String
      attribute :minerals, Array
      attribute :location, String
      attribute :original_name, String
      attribute :provider_type, String
      attribute :errors, Array

      # Validations
      validates :name, presence: true
      validates :minerals, presence: true
      validates :original_name, presence: true
      validates :provider_type, presence: true
      validates :location, presence: true

      #
      # Instance Methods
      #

      def initialize(params={})
        @name = params[:value_1]
        @minerals = params[:value_2]
        @location = params[:value_3]
        @original_name = params[:value_4]
        @provider_type = params[:value_5]
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
          minerals: minerals,
          location: location,
          status: 'Activo',
          original_name: original_name,
          provider_type: provider_type
        }
        if fields_mapping[:minerals].include?('ORO' || 'oro')
          r = format_values!(fields_mapping)
          Rucom.create!(r)
        else
          raise 'Este productor no puede comercializar ORO'
        end
      end
    end
  end
end
