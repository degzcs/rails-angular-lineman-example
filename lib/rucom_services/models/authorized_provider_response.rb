module RucomServices
  module Models
    # The  Autorized providers are: Chatarreros and Barequeros
    class AuthorizedProviderResponse
      include ActiveModel::Model
      include Virtus.model(nullify_blank: true)

      attr_accessor :rucom
      attribute :name, String
      attribute :minerals, String
      attribute :localization, String
      attribute :original_name, String
      attribute :provider_type, String

      # Validations
      validates :name, presence: true
      validates :minerals, presence: true
      validates :original_name, presence: true
      validates :provider_type, presence: true

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
        model_fields = {
          name: name,
          minerals: minerals,
          status: 'Activo',
          original_name: original_name,
          provider_type: provider_type
        }
        if model_fields[:minerals].include?('ORO' || 'oro')
          Rucom.create!(model_fields)
        else
          raise 'Este productor no puede comercializar ORO'
        end
      end
    end
  end
end
