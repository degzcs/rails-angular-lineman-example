class TraderResponse
  include Virtus.model(:nullify_blank => true)

  attribute :rucom_number, String
  attribute :name, string
  attribute :minerals, string
  attribute :state, string
end