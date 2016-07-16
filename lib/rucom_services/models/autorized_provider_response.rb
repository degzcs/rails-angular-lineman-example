# The  Autorized providers are: Chatarreros and Barequeros
class AutorizedProviderResponse
  include Virtus.model(:nullify_blank => true)

  attribute :name, String
  attribute :minerals, string
  attribute :localization, string
end