module RucomServices
  module Models
    # The  Autorized providers are: Chatarreros and Barequeros
    class AutorizedProviderResponse
      include Virtus.model(:nullify_blank => true)

      attribute :name, String
      attribute :minerals, String
      attribute :localization, String
    end
  end
end