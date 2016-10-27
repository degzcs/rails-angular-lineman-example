module V1
  module Entities
    # AuthorizedProvider entitiy to returns the resective user and profile informtation
    class AuthorizedProvider < Grape::Entity
      expose :id, documentation: { type: 'integer', desc: 'id of the user', example: '1' }
      expose :document_number, documentation: { type: 'string', desc: 'Document number of the provider', example: '1968353479' } do |user, _options|
        user.profile.document_number
      end
      expose :first_name, documentation: { type: 'string', desc: 'Firstname', example: 'Juan' } do |user, _options|
        user.profile.first_name
      end
      expose :last_name, documentation: { type: 'string', desc: 'Lastname', example: 'Perez' } do |user, _options|
        user.profile.last_name
      end
      expose :phone_number, documentation: { type: 'string', desc: 'Phone number', example: '83333333' } do |user, _options|
        user.profile.phone_number
      end
      expose :address, documentation: { type: 'string', desc: 'Address', example: 'Calle falsa n#4233' } do |user, _options|
        user.profile.address
      end
      expose :id_document_file, safe: true, documentation: { type: 'file', desc: 'file', example: '...' } do |user, _options|
        user.profile.id_document_file
      end
      expose :mining_authorization_file, safe: true, documentation: { type: 'file', desc: 'file', example: '...' } do |user, _options|
        user.profile.mining_authorization_file
      end
      expose :photo_file, safe: true, documentation: { type: 'file', desc: 'file', example: '...' } do |user, _options|
        user.profile.photo_file
      end
      expose :signature_picture, safe: true, documentation: { type: 'file', desc: 'file', example: '...' } do |user, _options|
        user.profile.habeas_data_agreetment_file
      end
      expose :email, documentation: { type: 'string', desc: 'E-mail address', example: 'provider@example.com' }
      expose :city, documentation: { type: 'string', desc: 'City name', example: 'Medellín' } do |user, _options|
        user.profile.city.as_json
      end
      expose :state, safe: true, documentation: { type: 'string', desc: 'State name', example: 'Antioquia' } do |user, _options|
        user.profile.city.state.as_json if user.profile.city.present?
      end
      expose :company, documentation: { type: 'json', desc: 'company_info', example: '' } do |user, _options|
        user.company.as_indexed_json if user.has_office?
      end
      expose :rucom, documentation: { type: 'json', desc: 'rucom', example: '' } do |user, _options|
        user.rucom.as_json
      end
      expose :provider_type, documentation: { type: 'string', desc: 'provider_type', example: '' }
    end
  end
end
