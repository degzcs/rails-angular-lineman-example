module RucomServices
  module Models

    class TraderResponse
      include Virtus.model(:nullify_blank => true)

      attribute :rucom_number, String
      attribute :name, String
      attribute :minerals, String
      attribute :state, String
    end
  end
end