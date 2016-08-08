module RucomServices
  module Models
    # The  Autorized providers are: Chatarreros and Barequeros
    class AutorizedProviderResponse
      include ActiveModel::Model
      include Virtus.model(nullify_blank: true)

      attr_accessor :rucom
      attribute :name, String
      attribute :minerals, String
      attribute :localization, String
      attribute :original_name, String

      # Validations
      validates :name, presence: true
      validates :minerals, presence: true
      validates :original_name, presence: true

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
        # user = User.create!(email: email)
        # @rucom = user.expenses.create!(amount: amount, paid: paid)
        # Status: values = 'Activo' | 'Inactivo'
        # This field dosen't return from rucom it will be set as:
        # 'Activo' when appears in the rucom database otherwise 
        model_fields = {
          name: name,
          minerals: minerals,
          status: 'Activo',
          original_name: original_name
        }
        Rucom.create!(model_fields)
      end
    end
  end
end
