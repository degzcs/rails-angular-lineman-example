module RucomServices
  module Models
    # This Class allows to valid and persist the data from the Formater Service
    class TraderResponse
      include ActiveModel::Model
      include Virtus.model(nullify_blank: true)

      attribute :rucom_number, String
      attribute :name, String
      attribute :minerals, String
      attribute :status, String
      attribute :original_name, String

      # Validations
      validates :rucom_number, presence: true
      validates :name, presence: true
      validates :minerals, presence: true
      validates :status, presence: true
      validates :original_name, presence: true

      def save
        if valid?
          persist!
          true
        else
          false
        end
      end

      private

      def persist!
        # user = User.create!(email: email)
        # @expense = user.expenses.create!(amount: amount, paid: paid)  -> this is an example
        model_fields = {
          rucom_number: rucom_number,
          name: name,
          minerals: minerals,
          status: status,
          original_name: original_name
        }
        Rucom.create!(model_fields)
      end
    end
  end
end
